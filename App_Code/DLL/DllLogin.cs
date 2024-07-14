using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DllUtility;
using System.Data.SqlClient;
using System.Data;
using System.Reflection.Emit;
using System.Web.UI.WebControls;

namespace DllLogin
{
    public class PL_Login : Utility
    {
        public string Name { get; set; }
        public int EmpAutoId { get; set; }
        public int EmpType { get; set; }
        public string UserName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int isActiveUser { get; set; }
        public string EmailID { get; set; }
        public string Phoneno { get; set; }
        public int UserType { get; set; }
        public int Userid { get; set; }
        public int LogInAutoId { get; set; }
        public int TerminalId { get; set; }
        public string Password { get; set; }
        public string NewPassword { get; set; }
        public string PageUrl { get; set; }

    }

    public class DL_Login
    {
        public static void ReturnTable(PL_Login pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcLoginMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode       ", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@EmpAutoId    ", pobj.EmpAutoId);
                sqlCmd.Parameters.AddWithValue("@LogInAutoId    ", pobj.LogInAutoId);
                sqlCmd.Parameters.AddWithValue("@EmpType      ", pobj.EmpType);
                sqlCmd.Parameters.AddWithValue("@FirstName    ", pobj.FirstName);
                sqlCmd.Parameters.AddWithValue("@LastName     ", pobj.LastName);
                sqlCmd.Parameters.AddWithValue("@isActiveUser ", pobj.isActiveUser);
                sqlCmd.Parameters.AddWithValue("@EmailID      ", pobj.EmailID);
                sqlCmd.Parameters.AddWithValue("@Phoneno      ", pobj.Phoneno);
                sqlCmd.Parameters.AddWithValue("@UserType     ", pobj.UserType);
                sqlCmd.Parameters.AddWithValue("@Userid       ", pobj.Userid);
                sqlCmd.Parameters.AddWithValue("@LoginID      ", pobj.UserName);
                sqlCmd.Parameters.AddWithValue("@TerminalId", pobj.TerminalId);
                sqlCmd.Parameters.AddWithValue("@Password", pobj.Password);
                sqlCmd.Parameters.AddWithValue("@NewPassword", pobj.NewPassword);
                sqlCmd.Parameters.AddWithValue("@IPAddress", pobj.IPAddress);
                sqlCmd.Parameters.AddWithValue("@PageUrl", pobj.PageUrl);
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

    public class BL_Login
    {
        public static void changePassword(PL_Login pobj)
        {
            pobj.Opcode = 21;
            DL_Login.ReturnTable(pobj);
        }
        public static void AssignTerminal(PL_Login pobj)
        {
            pobj.Opcode = 22;
            DL_Login.ReturnTable(pobj);
        }
        public static void login(PL_Login pobj)
        {
            pobj.Opcode = 41;
            DL_Login.ReturnTable(pobj);
        }
        public static void Bindlogo(PL_Login pobj)
        {
            pobj.Opcode = 42;
            DL_Login.ReturnTable(pobj);
        }
        public static void getPageAction(PL_Login pobj)
        {
            pobj.Opcode = 43;
            DL_Login.ReturnTable(pobj);
        }
        public static void getModuleList(PL_Login pobj)
        {
            pobj.Opcode = 44;
            DL_Login.ReturnTable(pobj);
        }
        public static void BindTerminal(PL_Login pobj)
        {
            pobj.Opcode = 45;
            DL_Login.ReturnTable(pobj);
        }
    }
}
