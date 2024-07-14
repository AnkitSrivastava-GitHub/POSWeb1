using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DllUtility;
using System.Data;
using System.Data.SqlClient;


namespace DLLTerminalMaster
{
    public class PL_TerminalMaster : Utility
    {
        public string TerminalName { get; set; }
        public int Status { get; set; }
        public int TerminalAutoId { get; set; }
        public string TerminalId { get; set; }
        public string TerminalAddress { get; set; }
        public String CurrentUser { get; set; }
        public int CompanyId { get; set; }
    }
    public class DAL_Login
    {
        public static void ReturnTable(PL_TerminalMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcTerminalMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@AutoId", pobj.TerminalAutoId);
                sqlCmd.Parameters.AddWithValue("@CompanyId", pobj.CompanyId);
                sqlCmd.Parameters.AddWithValue("@Terminalid", pobj.TerminalId);
                sqlCmd.Parameters.AddWithValue("@TerminalName", pobj.TerminalName);
                sqlCmd.Parameters.AddWithValue("@Status", pobj.Status);
                sqlCmd.Parameters.AddWithValue("@TerminalAddress", pobj.TerminalAddress);
                sqlCmd.Parameters.AddWithValue("@CurrentUser", pobj.CurrentUser);
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
    public class BAL_TerminalMaster
    {
        public static void BindCompany(PL_TerminalMaster pobj)
        {
            pobj.Opcode = 45;
            DAL_Login.ReturnTable(pobj);
        }
        public static void InsertTerminal(PL_TerminalMaster pobj)
        {
            pobj.Opcode = 11;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindTerminalList(PL_TerminalMaster pobj)
        {
            pobj.Opcode = 42;
            DAL_Login.ReturnTable(pobj);
        }
        public static void editTerminal(PL_TerminalMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_Login.ReturnTable(pobj);
        }
        public static void UpdateTerminal(PL_TerminalMaster pobj)
        {
            pobj.Opcode = 21;
            DAL_Login.ReturnTable(pobj);
        }
        public static void DeleteTerminal(PL_TerminalMaster pobj)
        {
            pobj.Opcode = 31;
            DAL_Login.ReturnTable(pobj);
        }

    }
}
