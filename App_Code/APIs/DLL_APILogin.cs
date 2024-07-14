using System;
using System.Data;
using System.Data.SqlClient;
using DllUtility;

namespace DLL_APILogin
{
    public class PL_APILogin : Utility
    {
        public int AutoId { get; set; }
        public int TerminalId { get; set; }
        public int LoginAutoId { get; set; }
        public string BalanceStatus { get; set; }
        public decimal OpeningBalance { get; set; }
        public DataTable DT_CurrencyListChild { get; set; }
        public DataTable CurrencyTable { get; set; }
        public string LoginId { get; set; }
        public string AccessToken { get; set; }
        public string Hashkey { get; set; }
        public string DeviceId { get; set; }
        public string LatLong { get; set; }
        public string AppVersion { get; set; }
        public string RequestSource { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public string NewPassword { get; set; }

        public PL_APILogin()
        {
            DT_CurrencyListChild = new DataTable();
            DT_CurrencyListChild.Columns.Add(new DataColumn("CurrencyID", typeof(System.Int32)));
            DT_CurrencyListChild.Columns.Add(new DataColumn("QTY", typeof(System.Int32)));
            
        }
    }
    public class DL_APILogin
    {
        public static void ReturnTable(PL_APILogin pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcAPI_Login", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@AutoId", pobj.AutoId);
                sqlCmd.Parameters.AddWithValue("@TerminalId", pobj.TerminalId);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                sqlCmd.Parameters.AddWithValue("@AccessToken", pobj.AccessToken);
                sqlCmd.Parameters.AddWithValue("@Hashkey", pobj.Hashkey);
                sqlCmd.Parameters.AddWithValue("@DeviceId", pobj.DeviceId);
                sqlCmd.Parameters.AddWithValue("@LatLong", pobj.LatLong);
                sqlCmd.Parameters.AddWithValue("@LoginAutoId", pobj.LoginAutoId);
                sqlCmd.Parameters.AddWithValue("@BalanceStatus", pobj.BalanceStatus);
                sqlCmd.Parameters.AddWithValue("@AppVersion", pobj.AppVersion);
                sqlCmd.Parameters.AddWithValue("@RequestSource", pobj.RequestSource);
                sqlCmd.Parameters.AddWithValue("@UserName", pobj.UserName);
                sqlCmd.Parameters.AddWithValue("@NewPassword", pobj.NewPassword);
                sqlCmd.Parameters.AddWithValue("@Password", pobj.Password);
                sqlCmd.Parameters.AddWithValue("@PageIndex", pobj.PageIndex);
                sqlCmd.Parameters.AddWithValue("@PageSize", pobj.PageSize);
                sqlCmd.Parameters.AddWithValue("@RecordCount", pobj.RecordCount);
                sqlCmd.Parameters.AddWithValue("@OpeningBalance", pobj.OpeningBalance);

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
    public class BL_APILogin
    {
        public static void ChnagePassword(PL_APILogin pobj)
        {
            pobj.Opcode = 21;
            DL_APILogin.ReturnTable(pobj);
        }
        public static void Login(PL_APILogin pobj)
        {
            pobj.Opcode = 41;
            DL_APILogin.ReturnTable(pobj);
        }
        public static void GetTerminalList(PL_APILogin pobj)
        {
            pobj.Opcode = 42;
            DL_APILogin.ReturnTable(pobj);
        }
        public static void GetCurrencyList(PL_APILogin pobj)
        {
            pobj.Opcode = 43;
            DL_APILogin.ReturnTable(pobj);
        }
        public static void ProceedCurrencyTerminal(PL_APILogin pobj)
        {
            pobj.Opcode = 44;
            DL_APILogin.ReturnTable(pobj);
        }
    }
}

