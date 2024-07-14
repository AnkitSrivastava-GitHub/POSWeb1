using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DllUtility;
using System.Data;
using System.Data.SqlClient;



namespace LogInUserdetail
{
    public class PL_LogInUserdetail : Utility
    {
        public string loginId { get; set; }
        public int Status { get; set; }
        public string UStatus { get; set; }
        public string UserId { get; set; }
        public int UserAutoId { get; set; }
        public int Store { get; set; }
        public string UserName { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }

    }
    public class DAL_Login
    {
        public static void ReturnTable(PL_LogInUserdetail pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcLogInLogDetail", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@opCode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@Userid", pobj.UserId);
                sqlCmd.Parameters.AddWithValue("@LoginID", pobj.loginId);
                sqlCmd.Parameters.AddWithValue("@UserName", pobj.UserName);
                //sqlCmd.Parameters.AddWithValue("@UserAutoId", pobj.UserAutoId);
                if (pobj.FromDate > DateTime.MinValue && pobj.FromDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@FromDate", pobj.FromDate);
                }
                if (pobj.ToDate > DateTime.MinValue && pobj.ToDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@ToDate", pobj.ToDate);
                }
                sqlCmd.Parameters.AddWithValue("@Store", pobj.Store);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                sqlCmd.Parameters.AddWithValue("@UStatus", pobj.UStatus);
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
    public class BAL_LogInUserdetail
    {
      
        public static void BindUser(PL_LogInUserdetail pobj)
        {
            pobj.Opcode = 41;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindUserList(PL_LogInUserdetail pobj)
        {
            pobj.Opcode = 42;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindUserListForDropDown(PL_LogInUserdetail pobj)
        {
            pobj.Opcode = 421;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindStoreLoginLogList(PL_LogInUserdetail pobj)
        {
            pobj.Opcode = 422;
            DAL_Login.ReturnTable(pobj);
        }
    }
}