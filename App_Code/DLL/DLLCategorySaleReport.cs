using DllUtility;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;

namespace DLLCategorySalesReport
{
    public class PL_CategorySalesReport : Utility
    {
        public int AutoId { get; set; }
        public int TerminalId { get; set; }
        public DateTime ReportDate { get; set; }

        public int ShiftId { get; set; }

    }
    public class DAL_CategorySalesReport
    {
        public static void ReturnTable(PL_CategorySalesReport pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcCategorySalesReport", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                sqlCmd.Parameters.AddWithValue("@TerminalId", pobj.TerminalId);
                sqlCmd.Parameters.AddWithValue("@ShiftId", pobj.ShiftId);
                if(pobj.ReportDate>DateTime.MinValue && pobj.ReportDate<DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@ReportDate", pobj.ReportDate);
                }
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
    public class BAL_CategorySalesReport
    {
        public static void InsertCustomer(PL_CategorySalesReport pobj)
        {
            pobj.Opcode = 11;
            DAL_CategorySalesReport.ReturnTable(pobj);
        }
        public static void BindTerminalList(PL_CategorySalesReport pobj)
        {
            pobj.Opcode = 41;
            DAL_CategorySalesReport.ReturnTable(pobj);
        }
        public static void BindCategorySalesReport(PL_CategorySalesReport pobj)
        {
            pobj.Opcode = 42;
            DAL_CategorySalesReport.ReturnTable(pobj);
        }
        public static void BindTicketSalesReport(PL_CategorySalesReport pobj)
        {
            pobj.Opcode = 43;
            DAL_CategorySalesReport.ReturnTable(pobj);
        }
        public static void BindPayoutReport(PL_CategorySalesReport pobj)
        {
            pobj.Opcode = 44;
            DAL_CategorySalesReport.ReturnTable(pobj);
        }
        public static void BindTransDetailsReport(PL_CategorySalesReport pobj)
        {
            pobj.Opcode = 45;
            DAL_CategorySalesReport.ReturnTable(pobj);
        }
        public static void getShiftList(PL_CategorySalesReport pobj)
        {
            pobj.Opcode = 46;
            DAL_CategorySalesReport.ReturnTable(pobj);
        }
    }
}