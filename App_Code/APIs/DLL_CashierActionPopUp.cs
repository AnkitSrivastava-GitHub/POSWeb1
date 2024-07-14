using DllUtility;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using APIsDLLUtility;


public class DLL_CashierActionPopUp
{
    public class PL_CashierActionPopUp : Utility
    {
        public int AutoId { get; set; }
        public int CustomerId { get; set; }
        public string SKUName { get; set; }
        public string ProductName { get; set; }
        public int OrderId { get; set; }
        public string OrderNo { get; set; }
        public decimal CashAmount { get; set; }
        public int TransactionAutoId { get; set; }
        public string LoginId { get; set; }
        public string Barcode { get; set; }
        public int Quantity { get; set; }
        public Decimal Discount { get; set; }
        public int ProductId { get; set; }
        public int SKUAutoId { get; set; }
        public int CartItemId { get; set; }
        public string AccessToken { get; set; }
        public string Hashkey { get; set; }
        public string DeviceId { get; set; }
        public string LatLong { get; set; }
        public string AppVersion { get; set; }
        public string RequestSource { get; set; }
        public string UserName { get; set; }
        public string SearchString { get; set; }
        public string SecurityPin { get; set; }
        public string Status { get; set; }
        public string ScreenName { get; set; }
        public string Type { get; set; }                 
        public int ScreenAutoId { get; set; }
        public string Remark { get; set; }
        public int Expense { get; set; }
        public int Vendor { get; set; }
        public string PayoutDate { get; set; }
        public string PayoutTime { get; set; }
        public string PayoutTo { get; set; }
        public string PaymentMode { get; set; }
        public int PayoutType { get; set; }
        public string DateTime { get; set; }
        public object Department { get; set; }
        public object ScreenId { get; set; }
        public object ShiftId { get; set; }
        public object FirstName { get; set; }
        public object CustomerIdV {  get; set; }
        public object LastName { get; set; }
        public object CouponCode { get; set; }
        public object DraftName { get; set; }
        public decimal TotalAmt { get; set; }
        public object MobileNo { get; set; }
        public object City { get; set; }
        public object State { get; set; }
        public object ZipCode { get; set; }
        public object DOB { get; set; }
        public decimal GiftCardAmt { get; set; }
        public object GiftCardNo { get; set; }
        public object EmailId { get; set; }
        public object Address { get; set; }
        public string BalanceStatus { get; set; }
        public decimal ClosingBalance { get; set; }
        public string CurrentBalanceStatus { get; set; }
        public decimal CurrentBalance { get; set; }
        public DataTable DT_CurrencyListChild { get; set; }
        public DataTable CurrencyTable { get; set; }
        public PL_CashierActionPopUp()
        {
            DT_CurrencyListChild = new DataTable();
            DT_CurrencyListChild.Columns.Add(new DataColumn("CurrencyID", typeof(System.Int32)));
            DT_CurrencyListChild.Columns.Add(new DataColumn("QTY", typeof(System.Int32)));

        }
    }

    public class DAL_CashierActionPopUp
    {
        public static void ReturnTable(PL_CashierActionPopUp pobj)
        {
            try
            {
                string host = HttpContext.Current.Request.Url.Host;
                string Scheme = "";
                if (host == "localhost")
                {
                    Scheme = "http://";
                }
                else
                {
                    Scheme = "https://";
                }
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcActionPopUp", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@LoginId", pobj.LoginId);
                sqlCmd.Parameters.AddWithValue("@URL", Scheme + HttpContext.Current.Request.Url.Authority);
                sqlCmd.Parameters.AddWithValue("@AutoId", pobj.AutoId);
                sqlCmd.Parameters.AddWithValue("@CartItemId", pobj.CartItemId);
                sqlCmd.Parameters.AddWithValue("@CustomerId", pobj.CustomerId);
                sqlCmd.Parameters.AddWithValue("@AccessToken", pobj.AccessToken);
                sqlCmd.Parameters.AddWithValue("@Hashkey", pobj.Hashkey);
                sqlCmd.Parameters.AddWithValue("@DeviceId", pobj.DeviceId);
                sqlCmd.Parameters.AddWithValue("@LatLong", pobj.LatLong);
                sqlCmd.Parameters.AddWithValue("@AppVersion", pobj.AppVersion);
                sqlCmd.Parameters.AddWithValue("@RequestSource", pobj.RequestSource);
                sqlCmd.Parameters.AddWithValue("@RecordCount", pobj.RecordCount);
                sqlCmd.Parameters.AddWithValue("@Status", pobj.Status);
                sqlCmd.Parameters.AddWithValue("@SearchString", pobj.SearchString);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                sqlCmd.Parameters.AddWithValue("@ScreenName", pobj.ScreenName);
                sqlCmd.Parameters.AddWithValue("@ScreenAutoId", pobj.ScreenAutoId);
                sqlCmd.Parameters.AddWithValue("@Action", pobj.Action);
                sqlCmd.Parameters.AddWithValue("@Remark", pobj.Remark);
                sqlCmd.Parameters.AddWithValue("@TerminalId", pobj.TerminalId);
                sqlCmd.Parameters.AddWithValue("@Department", pobj.Department);
                sqlCmd.Parameters.AddWithValue("@ScreenId", pobj.ScreenId);
                sqlCmd.Parameters.AddWithValue("@Type", pobj.Type);
                sqlCmd.Parameters.AddWithValue("@ProductId", pobj.ProductId);
                sqlCmd.Parameters.AddWithValue("@ShiftId", pobj.ShiftId);
                sqlCmd.Parameters.AddWithValue("@ClosingBalance", pobj.ClosingBalance);
                sqlCmd.Parameters.AddWithValue("@BalanceStatus", pobj.BalanceStatus);
                sqlCmd.Parameters.AddWithValue("@CurrentBalanceStatus", pobj.CurrentBalanceStatus);
                sqlCmd.Parameters.AddWithValue("@CurrentBalance", pobj.CurrentBalance);
                sqlCmd.Parameters.AddWithValue("@SKUAutoId", pobj.SKUAutoId);
                sqlCmd.Parameters.AddWithValue("@Quantity", pobj.Quantity);
                sqlCmd.Parameters.AddWithValue("@Barcode", pobj.Barcode);
                sqlCmd.Parameters.AddWithValue("@OrderNo", pobj.OrderNo);
                sqlCmd.Parameters.AddWithValue("@ProductName", pobj.ProductName);
                sqlCmd.Parameters.AddWithValue("@TransactionAutoId", pobj.TransactionAutoId);
                sqlCmd.Parameters.AddWithValue("@CashAmount", pobj.CashAmount);

                sqlCmd.Parameters.AddWithValue("@FirstName", pobj.FirstName);
                sqlCmd.Parameters.AddWithValue("@LastName", pobj.LastName);
                sqlCmd.Parameters.AddWithValue("@MobileNo", pobj.MobileNo);
                sqlCmd.Parameters.AddWithValue("@EmailId", pobj.EmailId);
                sqlCmd.Parameters.AddWithValue("@DOB", pobj.DOB);
                sqlCmd.Parameters.AddWithValue("@Address", pobj.Address);
                sqlCmd.Parameters.AddWithValue("@City", pobj.City);
                sqlCmd.Parameters.AddWithValue("@State", pobj.State);
                sqlCmd.Parameters.AddWithValue("@ZipCode", pobj.ZipCode);
                sqlCmd.Parameters.AddWithValue("@CustomerIdV", pobj.CustomerIdV);
                sqlCmd.Parameters.AddWithValue("@SecurityPin", pobj.SecurityPin);

                sqlCmd.Parameters.AddWithValue("@Expense", pobj.Expense);
                sqlCmd.Parameters.AddWithValue("@Vendor", pobj.Vendor);
                sqlCmd.Parameters.AddWithValue("@PaymentMode", pobj.PaymentMode);
                sqlCmd.Parameters.AddWithValue("@PayoutDate", pobj.PayoutDate);
                sqlCmd.Parameters.AddWithValue("@PayoutTo", pobj.PayoutTo);
                sqlCmd.Parameters.AddWithValue("@PayoutTime", pobj.PayoutTime);
                sqlCmd.Parameters.AddWithValue("@PayoutType", pobj.PayoutType);
                sqlCmd.Parameters.AddWithValue("@DateTime", pobj.DateTime);

                sqlCmd.Parameters.AddWithValue("@GiftCardNo", pobj.GiftCardNo);
                sqlCmd.Parameters.AddWithValue("@GiftCardAmt", pobj.GiftCardAmt);
                sqlCmd.Parameters.AddWithValue("@SKUName", pobj.SKUName);
                sqlCmd.Parameters.AddWithValue("@OrderId", pobj.OrderId);
                sqlCmd.Parameters.AddWithValue("@CouponCode", pobj.CouponCode);
                sqlCmd.Parameters.AddWithValue("@TotalAmt", pobj.TotalAmt);
                sqlCmd.Parameters.AddWithValue("@DraftName", pobj.DraftName);

                if (pobj.DT_CurrencyListChild != null)
                {
                    if (pobj.DT_CurrencyListChild.Rows.Count > 0)
                    {
                        sqlCmd.Parameters.AddWithValue("@DT_CurrencyListChild", pobj.DT_CurrencyListChild);
                    }
                }

                sqlCmd.Parameters.Add("@isException", SqlDbType.Bit);
                sqlCmd.Parameters["@isException"].Direction = ParameterDirection.Output;

                sqlCmd.Parameters.Add("@exceptionMessage", SqlDbType.VarChar, 500);
                sqlCmd.Parameters["@exceptionMessage"].Direction = ParameterDirection.Output;

                sqlCmd.Parameters.Add("@responseCode", SqlDbType.VarChar, 10);
                sqlCmd.Parameters["@responseCode"].Direction = ParameterDirection.Output;

                SqlDataAdapter sqlAdp = new SqlDataAdapter(sqlCmd);
                pobj.Ds = new DataSet();
                sqlAdp.Fill(pobj.Ds);
                pobj.isException = Convert.ToBoolean(sqlCmd.Parameters["@isException"].Value);
                pobj.exceptionMessage = sqlCmd.Parameters["@exceptionMessage"].Value.ToString();
                pobj.responseCode = sqlCmd.Parameters["@responseCode"].Value.ToString();
            }
            catch (Exception ex)
            {
                pobj.isException = true;
                pobj.exceptionMessage = ex.Message;
            }
        }
    }
    public class BAL_CashierActionPopUp
    {
        public static void GetScreenList(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 41;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void SaveScreen(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 31;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void NoSale(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 11;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void GetAddToScreenProductList(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 12;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void GetActionButtonList(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 13;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void GetEndShiftDetails(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 14;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void ProceedClosingDetails(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 15;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void AddProductToScreens(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 16;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void GetScreenProductList(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 17;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }

        public static void GetMultiPackingProduct(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 18;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void GetProductPackingDetails(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 19;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void GetProductFromBarcode(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 20;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void GetProductBySearch(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 21;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void AddCustomer(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 22;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void GetCustomerList(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 23;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void ClockInOut(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 24;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void AddGiftCard(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 25;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void ApplyGiftCard(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 26;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void GetCouponDetails(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 27;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void GetCustomerDetails(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 28;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void GetPayNowButtonList(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 29;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void GetRewardPointDetails(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 30;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void GetCreditCardList(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 32;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void GetSecurityPin(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 33;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void DraftOrder(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 34;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }

        public static void DeleteDraftOrder(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 35;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void GetDraftList(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 36;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void Payout(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 37;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void GetPayoutList(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 38;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
        public static void CashTransaction(PL_CashierActionPopUp pobj)
        {
            pobj.Opcode = 39;
            DAL_CashierActionPopUp.ReturnTable(pobj);
        }
    }
}
