using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DllUtility;
using System.Data;
using System.Data.SqlClient;

public class DLLGiftCardReport
{
    public class PL_GiftCarddetail : Utility
    {
        public int Status { get; set; }
        public int Store { get; set; }
        public int InvoiceAutoId { get; set; }
        public int Terminal { get; set; }
        public string Mobile { get; set; }
        public string GiftCode { get; set; }
        public string CustomerName { get; set; }
        public string Email { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }

    }
    public class DAL_Login
    {
        public static void ReturnTable(PL_GiftCarddetail pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcGiftCardReport", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@opCode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@InvoiceAutoId", pobj.InvoiceAutoId);
                sqlCmd.Parameters.AddWithValue("@Terminal", pobj.Terminal);
                sqlCmd.Parameters.AddWithValue("@Mobile", pobj.Mobile);
                sqlCmd.Parameters.AddWithValue("@Email", pobj.Email);
                sqlCmd.Parameters.AddWithValue("@Store", pobj.Store);
                if (pobj.FromDate > DateTime.MinValue && pobj.FromDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@FromDate", pobj.FromDate);
                }
                if (pobj.ToDate > DateTime.MinValue && pobj.ToDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@ToDate", pobj.ToDate);
                }
                sqlCmd.Parameters.AddWithValue("@CustomerName", pobj.CustomerName);
                sqlCmd.Parameters.AddWithValue("@GiftCode", pobj.GiftCode);
                sqlCmd.Parameters.AddWithValue("@Status", pobj.Status);
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

    public class BAL_GiftCarddetail
    {
        public static void BindGiftCard(PL_GiftCarddetail pobj)
        {
            pobj.Opcode = 42;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindGiftCardSearch(PL_GiftCarddetail pobj)
        {
            pobj.Opcode = 43;
            DAL_Login.ReturnTable(pobj);
        }
    }
}