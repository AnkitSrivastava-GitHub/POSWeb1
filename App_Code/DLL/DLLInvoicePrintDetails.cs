using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;
using System.Reflection.Emit;
using System.Web.UI.WebControls;
using DllUtility;


public class DLLInvoicePrintDetails
{
    public class PL_InvoicePrintDetails : Utility
    {
        public string StoreName { get; set; }
        public string Billingaddress { get; set; }
        public string ContactPerson { get; set; }
        public string country { get; set; }
        public string mobileNo { get; set; }
        public string Website { get; set; }
        public string state { get; set; }
        public string City { get; set; }
        public string ZipCode { get; set; }
        public string EmailId { get; set; }
        public string CLogo { get; set; }
        public int AutoId { get; set; }
        public int ShowFooter { get; set; }
        public int ShowLogo { get; set; }
        public int ShowHappyPoints { get; set; }
        public string Footer { get; set; }

    }

    public class DAL_Login
    {
        public static void ReturnTable(PL_InvoicePrintDetails pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcInvoicePrintDetails", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@StoreName", pobj.StoreName);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);

                sqlCmd.Parameters.AddWithValue("@Billingaddress", pobj.Billingaddress);
                sqlCmd.Parameters.AddWithValue("@ContactPerson", pobj.ContactPerson);
                sqlCmd.Parameters.AddWithValue("@country", pobj.country);
                sqlCmd.Parameters.AddWithValue("@mobileNo", pobj.mobileNo);
                sqlCmd.Parameters.AddWithValue("@Website", pobj.Website);
                sqlCmd.Parameters.AddWithValue("@state", pobj.state);
                sqlCmd.Parameters.AddWithValue("@City", pobj.City);
                sqlCmd.Parameters.AddWithValue("@ZipCode", pobj.ZipCode);
                sqlCmd.Parameters.AddWithValue("@EmailId", pobj.EmailId);
                sqlCmd.Parameters.AddWithValue("@CLogo", pobj.CLogo);
                sqlCmd.Parameters.AddWithValue("@AutoId", pobj.AutoId);
                sqlCmd.Parameters.AddWithValue("@ShowFooter", pobj.ShowFooter);
                sqlCmd.Parameters.AddWithValue("@ShowLogo", pobj.ShowLogo);
                sqlCmd.Parameters.AddWithValue("@ShowHappyPoints", pobj.ShowHappyPoints);
                sqlCmd.Parameters.AddWithValue("@Footer", pobj.Footer);

                sqlCmd.Parameters.AddWithValue("@Who", pobj.Who);
                sqlCmd.Parameters.AddWithValue("@PageIndex", pobj.PageIndex);
                sqlCmd.Parameters.AddWithValue("@PageSize", pobj.PageSize);
                sqlCmd.Parameters.AddWithValue("@RecordCount", pobj.RecordCount);
                sqlCmd.Parameters.Add("@isException", SqlDbType.Bit);
                sqlCmd.Parameters["@isException"].Direction = ParameterDirection.Output;
                sqlCmd.Parameters.Add("@exceptionMessage", SqlDbType.VarChar, 500);
                sqlCmd.Parameters["@exceptionMessage"].Direction = ParameterDirection.Output;
                SqlDataAdapter sqlAdp = new SqlDataAdapter(sqlCmd);
                pobj.Ds = new DataSet();
                sqlAdp.Fill(pobj.Ds);
                pobj.isException = Convert.ToBoolean(sqlCmd.Parameters["@isException"].Value);
                pobj.exceptionMessage = sqlCmd.Parameters["@exceptionMessage"].Value.ToString();
            }
            catch (Exception ex)
            {
                pobj.isException = true;
                pobj.exceptionMessage = ex.Message;
            }
        }
    }
    public class BAL_InvoicePrintDetails
    {
        public static void UpdateInvoicePrintDetails(PL_InvoicePrintDetails pobj)
        {
            pobj.Opcode = 21;
            DAL_Login.ReturnTable(pobj);
        }
        public static void EditInvoicePrintDetails(PL_InvoicePrintDetails pobj)
        {
            pobj.Opcode = 41;
            DAL_Login.ReturnTable(pobj);
        }        
    }
}