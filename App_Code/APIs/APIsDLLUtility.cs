using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Reflection;
using System.Text;
using System.Web;

namespace APIsDLLUtility
{
    public class API_Utility
    {
        public DataSet Ds;
        public int Opcode { get; set; }
        public string exceptionMessage { get; set; }
        public bool isException { get; set; }

        public static string ErrorLog(string prefix, string remark)
        {
            try
            {
                StringBuilder log = new StringBuilder();
                log.Append("*****  Log Start  *****");
                log.Append("\n[" + DateTime.Now.ToString() + "]");
                log.Append("\n[API Method]\t" + prefix);
                log.Append("\n[Stack Trace]\t" + remark);
                log.Append("\n*****  Log End  *****");
                LogFileWrite(log.ToString());
                return "";
            }
            catch (Exception ex)
            {
                return "[Error]" + ex.Message + " [ST]" + ex.StackTrace;
            }
        }

        public static void LogFileWrite(string message)
        {
            FileStream fileStream = null;
            StreamWriter streamWriter = null;
            try
            {
                string logFilePath = "";
                //logFilePath = Server.MapPath("~/");
                logFilePath = HttpContext.Current.Server.MapPath("~/AccessLog");
                logFilePath = logFilePath + "/ProgramLog" + "-" + DateTime.Today.ToString("yyyyMMdd") + "." + "txt";
                if (logFilePath.Equals("")) return;
                #region Create the Log file directory if it does not exists
                DirectoryInfo logDirInfo = null;
                FileInfo logFileInfo = new FileInfo(logFilePath);
                logDirInfo = new DirectoryInfo(logFileInfo.DirectoryName);
                if (!logDirInfo.Exists) logDirInfo.Create();
                #endregion Create the Log file directory if it does not exists

                if (!logFileInfo.Exists)
                {
                    fileStream = logFileInfo.Create();
                }
                else
                {
                    fileStream = new FileStream(logFilePath, FileMode.Append);
                }
                streamWriter = new StreamWriter(fileStream);
                streamWriter.WriteLine(message);
            }
            finally
            {
                if (streamWriter != null) streamWriter.Close();
                if (fileStream != null) fileStream.Close();
            }
        }

        public string base64String = null;

        public System.Drawing.Image Base64ToImage()
        {
            byte[] imageBytes = Convert.FromBase64String(base64String);
            MemoryStream ms = new MemoryStream(imageBytes, 0, imageBytes.Length);
            ms.Write(imageBytes, 0, imageBytes.Length);
            System.Drawing.Image image = System.Drawing.Image.FromStream(ms, true);
            return image;
        }
    }

    public class API_DataEncodeDecode
    {
        public string EncodePasswordToBase64(string password)
        {
            try
            {
                byte[] encData_byte = new byte[password.Length];
                encData_byte = System.Text.Encoding.UTF8.GetBytes(password);
                string encodedData = Convert.ToBase64String(encData_byte);
                return encodedData;
            }
            catch (Exception ex)
            {
                throw new Exception("Error in base64Encode" + ex.Message);
            }
        }

        public string DecodeFrom64(string encodedData)//this function Convert to Decord your Password
        {
            System.Text.UTF8Encoding encoder = new System.Text.UTF8Encoding();
            System.Text.Decoder utf8Decode = encoder.GetDecoder();
            byte[] todecode_byte = Convert.FromBase64String(encodedData);
            int charCount = utf8Decode.GetCharCount(todecode_byte, 0, todecode_byte.Length);
            char[] decoded_char = new char[charCount];
            utf8Decode.GetChars(todecode_byte, 0, todecode_byte.Length, decoded_char, 0);
            string result = new String(decoded_char);
            return result;
        }

        public string generatePassword()
        {
            int lenthofpass = 4;
            string allowedChars = "1,2,3,4,5,6,7,8,9,0";
            char[] sep = { ',' };
            string[] arr = allowedChars.Split(sep);
            string passwordString = "", temp = "";
            Random rand = new Random();
            for (int i = 0; i < lenthofpass; i++)
            {
                temp = arr[rand.Next(0, arr.Length)];
                passwordString += temp;
            }
            return passwordString;
        }
    }

    public class API_gZipCompression
    {
        public static void fn_gZipCompression()
        {
            HttpResponse Response = HttpContext.Current.Response;
            string AcceptEncoding = HttpContext.Current.Request.Headers["Accept-Encoding"];
            if (AcceptEncoding.Contains("gzip"))
            {
                Response.Filter = new System.IO.Compression.GZipStream(Response.Filter,
                                          System.IO.Compression.CompressionMode.Compress);
                Response.AppendHeader("Content-Encoding", "gzip");
            }
            else
            {
                Response.Filter = new System.IO.Compression.DeflateStream(Response.Filter,
                                          System.IO.Compression.CompressionMode.Compress);
                Response.AppendHeader("Content-Encoding", "deflate");
            }
        }
    }

    public class ResponseContainer
    {
        public string responseMessage;
        public string responseCode;

        public Object responseData;
    }

    public class requestContainer
    {
        public string AccessToken;
        public string Hashkey;
        public string DeviceId;
        public string LatLong;
        public string AppVersion;
        public string RequestSource;
        public string LoginId;
        public int AutoId;
    }


    public class requestData
    {
        public string UserName;
        public string ScreenName;
        public string InvoiceNo;
        public int InvoiceAutoId;
        public string CustomerName;
        public string InvoiceFromDate;
        public string InvoiceToDate;
        public string SearchString;
        public string SecurityPin;
        public string Department;
        public string ScreenId;
        public string Status;
        public string Password;
        public string ProductName;
        public string Barcode;
        public string OrderNo;
        public string SKUName;
        public string CoupanNo;
        public decimal CoupanAmount;
        public string Name;
        public string MobileNo;
        public string EmailId;
        public string PaymentMethod;
        public int CategoryId;
        public int StoreId;
        public int SKUAutoId;
        public int ShiftId;
        public string DDLString;
        public string Remark;

        //...........Payout..............
        public int Expense;
        public int Vendor;
        public string PayoutDate;
        public string PayoutTime;
        public string PayoutTo;
        public string PaymentMode;
        public int PayoutType;
        //...........Payout..............

        public string DateTime;
        public int Action;
        public int ScreenAutoId;
        public int TerminalId;
        public int LoginAutoId;
        public string BalanceStatus;
        public decimal OpeningBalance;
        public string FirstName;
        public string CustomerIdV;
        public decimal ClosingBalance;
        public string CurrentBalanceStatus;
        public decimal CurrentBalance;
        public List<dtCurrencyTable> CurrencyTable { get; set; }
        public string LastName;
        public decimal GiftCardAmt;
        public string GiftCardNo;
        public string CouponCode;
        public int CustomerAutoId;
        public decimal TotalAmt;
        public string DOB;
        public string Address;
        public string State;
        public string City;
        public decimal SKUAmt;
        public string GiftCardCode;
        public string ZipCode;
        public int OrderId;
        public int CartItemId;
        public int CustomerId;
        public decimal Discount;
        public int Quantity;
        public int ProductId;
        public int BrandId;
        public int Favourite;
        public int PageIndex;
        public int PageSize;
        public string Type;
        public string DraftName;
        public int TransactionAutoId;
        public decimal CashAmount;
    }
    
    public class dtCurrencyTable
    {
        public int CurrencyID { get; set; }
        public int QTY { get; set; }
    }


    public class Common
    {
        public DataTable ToDataTable<T>(List<T> items)
        {
            DataTable dataTable = new DataTable(typeof(T).Name);
            PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (PropertyInfo prop in Props)
            {
                dataTable.Columns.Add(prop.Name);
            }
            foreach (T item in items)
            {
                var values = new object[Props.Length];
                for (int i = 0; i < Props.Length; i++)
                {
                    values[i] = Props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }
            return dataTable;
        }
    }
}
