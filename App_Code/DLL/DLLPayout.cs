using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using DllUtility;


namespace DLLPayout
{
    public class PL_PayoutMaster : Utility
    {
        public string PayTo { get; set; }
        public string Remark { get; set; }
        public Decimal Amount { get; set; }
        public string PaymentMode { get; set; }
        public string TransactionId { get; set; }
        public int PayoutAutoId { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime PayoutDate {  get; set; }
        public string PayoutTime { get; set; }
        public int CompanyId { get; set; }
        public int Expense { get; set; }
        public int Vendor { get; set; }
        public int PayoutType { get; set; }
        public int TerminalAutoId { get; set;}
        public int ShiftId { get; set; }

    }
    public class DAL_PayoutMaster
    {
        public static void ReturnTable(PL_PayoutMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcPayoutMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);

                sqlCmd.Parameters.AddWithValue("@Vendor", pobj.Vendor);
                sqlCmd.Parameters.AddWithValue("@Expense", pobj.Expense);
                sqlCmd.Parameters.AddWithValue("@PayoutType", pobj.PayoutType);
                if (pobj.PayoutDate > DateTime.MinValue && pobj.PayoutDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@PayoutDate", pobj.PayoutDate);
                }
                sqlCmd.Parameters.AddWithValue("@PayoutTime", pobj.PayoutTime);
                sqlCmd.Parameters.AddWithValue("@PayoutAutoId", pobj.PayoutAutoId);
                sqlCmd.Parameters.AddWithValue("@CompanyId", pobj.CompanyId);
                sqlCmd.Parameters.AddWithValue("@PayTo", pobj.PayTo);
                sqlCmd.Parameters.AddWithValue("@Remark", pobj.Remark);
                sqlCmd.Parameters.AddWithValue("@Amount", pobj.Amount); 
                sqlCmd.Parameters.AddWithValue("@ShiftId", pobj.ShiftId);
                sqlCmd.Parameters.AddWithValue("@PayoutMode", pobj.PaymentMode);
                sqlCmd.Parameters.AddWithValue("@TransactionId", pobj.TransactionId);
                sqlCmd.Parameters.AddWithValue("@TerminalAutoId", pobj.TerminalAutoId);

                if (pobj.CreatedDate > DateTime.MinValue && pobj.CreatedDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@CreatedDate", pobj.CreatedDate);
                }
                if (pobj.FromDate > DateTime.MinValue && pobj.FromDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@FromDate", pobj.FromDate);
                }
                if (pobj.ToDate > DateTime.MinValue && pobj.ToDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@ToDate", pobj.ToDate);
                }

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
    public class BAL_PayoutMaster
    {
        public static void InsertPayout(PL_PayoutMaster pobj)
        {
            pobj.Opcode = 11;
            DAL_PayoutMaster.ReturnTable(pobj);
        }
        public static void BindPayoutList(PL_PayoutMaster pobj)
        {
            pobj.Opcode = 42;
            DAL_PayoutMaster.ReturnTable(pobj);
        }
        public static void BindPayoutList1(PL_PayoutMaster pobj)
        {
            pobj.Opcode = 43;
            DAL_PayoutMaster.ReturnTable(pobj);
        }
        public static void editPayout(PL_PayoutMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_PayoutMaster.ReturnTable(pobj);
        }
        public static void UpdatePayout(PL_PayoutMaster pobj)
        {
            pobj.Opcode = 21;
            DAL_PayoutMaster.ReturnTable(pobj);
        }
        public static void DeletePayout(PL_PayoutMaster pobj)
        {
            pobj.Opcode = 31;
            DAL_PayoutMaster.ReturnTable(pobj);
        }
        public static void BindTermianl(PL_PayoutMaster pobj)
        {
            pobj.Opcode = 45;
            DAL_PayoutMaster.ReturnTable(pobj);
        }
    }
}