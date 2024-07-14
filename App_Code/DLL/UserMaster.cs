using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using DllUtility;


namespace UserMaster
{
    public class PL_UserMaster : Utility
    {
        public string loginId { get; set; }
        public string Password { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string EmailId { get; set; }
        public string PhoneNo { get; set; }
        public string UserType { get; set; }
        public string Status { get; set; }
        public string AllowedApp {  get; set; }
        public string UserId { get; set; }
        public int UserAutoId { get; set; }
        public int ModuleID { get; set; }
        public int ModuleId { get; set; }
        public string Security { get; set; }
        public string SecurityDisc { get; set; }
        public decimal HourlyRate { get; set; } 
        public string securityWithdraw { get; set; }
        public int CompanyId { get; set; }
        public string ComponentIds { get; set; }
        public string ComponentIdsList { get; set; }
        public string StoreIdsList { get; set; }
    }
    public class DAL_Login
    {
        public static void ReturnTable(PL_UserMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcUserDetail", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@opCode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@Userid", pobj.UserId);
                sqlCmd.Parameters.AddWithValue("@Password", pobj.Password);
                sqlCmd.Parameters.AddWithValue("@LoginID", pobj.loginId);
                sqlCmd.Parameters.AddWithValue("@StoreIdsList", pobj.StoreIdsList); 
                sqlCmd.Parameters.AddWithValue("@ComponentIds", pobj.ComponentIds);
                sqlCmd.Parameters.AddWithValue("@ComponentIdsList", pobj.ComponentIdsList);
                sqlCmd.Parameters.AddWithValue("@ModuleId", pobj.ModuleId);

                sqlCmd.Parameters.AddWithValue("@CompanyId", pobj.CompanyId);
                sqlCmd.Parameters.AddWithValue("@FirstName", pobj.FirstName);
                sqlCmd.Parameters.AddWithValue("@LastName", pobj.LastName);
                sqlCmd.Parameters.AddWithValue("@EmailID", pobj.EmailId);
                sqlCmd.Parameters.AddWithValue("@UserAutoId", pobj.UserAutoId);
                sqlCmd.Parameters.AddWithValue("@Phoneno", pobj.PhoneNo);
                sqlCmd.Parameters.AddWithValue("@UserType", pobj.UserType);
                sqlCmd.Parameters.AddWithValue("@AllowedApp", pobj.AllowedApp);

                sqlCmd.Parameters.AddWithValue("@HourlyRate", pobj.HourlyRate); 
                sqlCmd.Parameters.AddWithValue("@Securitypin", pobj.Security);
                sqlCmd.Parameters.AddWithValue("@SecuritypinDisc", pobj.SecurityDisc);
                sqlCmd.Parameters.AddWithValue("@securityWithdraw", pobj.securityWithdraw);

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
    public class BAL_UserMaster
    {
        public static void InsertUser(PL_UserMaster pobj)
        {
            pobj.Opcode = 11;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindUserList(PL_UserMaster pobj)
        {
            pobj.Opcode = 42;
            DAL_Login.ReturnTable(pobj);
        }

        public static void DeleteUser(PL_UserMaster pobj)
        {
            pobj.Opcode = 31;
            DAL_Login.ReturnTable(pobj);
        }
        public static void editUserDetail(PL_UserMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_Login.ReturnTable(pobj);
        }
        public static void UpdateUser(PL_UserMaster pobj)
        {
            pobj.Opcode = 21;
            DAL_Login.ReturnTable(pobj);
        }
        public static void MyAccount(PL_UserMaster pobj)
        {
            pobj.Opcode = 22;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindUserType(PL_UserMaster pobj)
        {
            pobj.Opcode = 45;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindModule(PL_UserMaster pobj)
        {
            pobj.Opcode = 46;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindSubModule(PL_UserMaster pobj)
        {
            pobj.Opcode = 47;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindComponentList(PL_UserMaster pobj)
        {
            pobj.Opcode = 48;
            DAL_Login.ReturnTable(pobj);
        }
        public static void AssignModule(PL_UserMaster pobj)
        {
            pobj.Opcode = 49;
            DAL_Login.ReturnTable(pobj);
        }

        public static void ShowAssignedModule(PL_UserMaster pobj)
        {
            pobj.Opcode = 50;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindStoreList(PL_UserMaster pobj)
        {
            pobj.Opcode = 51;
            DAL_Login.ReturnTable(pobj);
        }
    }

}
