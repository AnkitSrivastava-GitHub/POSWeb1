using DllUtility;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Linq;
using System.Web;

namespace DLLZReport
{
    public class PL_ZReport : Utility
    {
        public int AutoId { get; set; }
        public int TerminalId { get; set; }
        public int ShiftId { get; set; }
        public DateTime ZReportDate { get; set; }
    }
    public class DAL_ZReport
    {
        public static void ReturnTable(PL_ZReport pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("Proc_ZReport", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@AutoId", pobj.AutoId);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                sqlCmd.Parameters.AddWithValue("@Who", pobj.Who);
                sqlCmd.Parameters.AddWithValue("@TerminalId", pobj.TerminalId);
                sqlCmd.Parameters.AddWithValue("@ShiftId", pobj.ShiftId);
                if (pobj.ZReportDate > DateTime.MinValue && pobj.ZReportDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@ZReportDate", pobj.ZReportDate);
                }
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
    public class BAL_ZReport
    {
        public static void Print_ZReport(PL_ZReport pobj)
        {
            pobj.Opcode = 41;
            DAL_ZReport.ReturnTable(pobj);
        }
        public static void BindTerminalList(PL_ZReport pobj)
        {
            pobj.Opcode = 42;
            DAL_ZReport.ReturnTable(pobj);
        }
    }
}