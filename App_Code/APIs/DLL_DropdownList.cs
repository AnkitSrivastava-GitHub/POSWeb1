using DllUtility;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using APIsDLLUtility;

public class DLL_DropdownList
{
    public class PL_DropdownList : Utility
    {
        public int AutoId { get; set; }
        public int CustomerId { get; set; }
        public string LoginId { get; set; }        
        public string AccessToken { get; set; }
        public string Hashkey { get; set; }
        public string DeviceId { get; set; }
        public string LatLong { get; set; }
        public string AppVersion { get; set; }
        public string RequestSource { get; set; }
        public string UserName { get; set; }
        public string SearchString { get; set; }
        public string Status { get; set; }
        public string DDLString { get; set; }
    }

    public class DAL_DropdownList
    {
        public static void ReturnTable(PL_DropdownList pobj)
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
                SqlCommand sqlCmd = new SqlCommand("ProcDropdownList", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@LoginId", pobj.LoginId);
                sqlCmd.Parameters.AddWithValue("@URL", Scheme + HttpContext.Current.Request.Url.Authority);
                sqlCmd.Parameters.AddWithValue("@AutoId", pobj.AutoId);
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
                sqlCmd.Parameters.AddWithValue("@DDLString", pobj.DDLString);
                sqlCmd.Parameters.AddWithValue("@Action", pobj.Action);
                sqlCmd.Parameters.AddWithValue("@TerminalId", pobj.TerminalId);

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
    public class BAL_DropdownList
    {
        public static void GetDropdownList(PL_DropdownList pobj)
        {
            pobj.Opcode = 41;
            DAL_DropdownList.ReturnTable(pobj);
        }
        public static void StatusList(PL_DropdownList pobj)
        {
            pobj.Opcode = 42;
            DAL_DropdownList.ReturnTable(pobj);
        }
        public static void PayoutTypeList(PL_DropdownList pobj)
        {
            pobj.Opcode = 43;
            DAL_DropdownList.ReturnTable(pobj);
        }
    }
}
