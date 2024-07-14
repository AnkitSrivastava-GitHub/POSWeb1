using System;
using System.Collections.Generic;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using DllUtility;


namespace CustomerMaster
{
    public class PL_CustomerMaster:Utility
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string MobileNo { get; set; }
        public string EmailId { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public int State { get; set; }
        public string ZipCode { get; set; }
        public string DOB { get; set; }
        public string Country { get; set; }
        public int CustomerAutoId { get; set; }

    }
    public class DAL_Login
    {
        public static void ReturnTable(PL_CustomerMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcCustomerMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@AutoId", pobj.CustomerAutoId);
                sqlCmd.Parameters.AddWithValue("@FirstName", pobj.FirstName);
                sqlCmd.Parameters.AddWithValue("@LastName", pobj.LastName);
                sqlCmd.Parameters.AddWithValue("@DOB", pobj.DOB);
                sqlCmd.Parameters.AddWithValue("@MobileNo", pobj.MobileNo);
                sqlCmd.Parameters.AddWithValue("@EmailId", pobj.EmailId);
                sqlCmd.Parameters.AddWithValue("@Address", pobj.Address);
                sqlCmd.Parameters.AddWithValue("@State", pobj.State);
                sqlCmd.Parameters.AddWithValue("@City", pobj.City);
                sqlCmd.Parameters.AddWithValue("@Country", pobj.Country);
                sqlCmd.Parameters.AddWithValue("@ZipCode", pobj.ZipCode);
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
    public class BAL_CustomerMaster
    {
        public static void InsertCustomer(PL_CustomerMaster pobj)
        {
            pobj.Opcode = 11;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindCustomerList(PL_CustomerMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_Login.ReturnTable(pobj);
        }
        public static void DeleteCustomer(PL_CustomerMaster pobj)
        {
            pobj.Opcode = 31;
            DAL_Login.ReturnTable(pobj);
        }
        public static void editCustomerDetail(PL_CustomerMaster pobj)
        {
            pobj.Opcode = 42;
            DAL_Login.ReturnTable(pobj);
        }
        public static void UpdateCustomer(PL_CustomerMaster pobj)
        {
            pobj.Opcode = 21;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindState(PL_CustomerMaster pobj)
        {
            pobj.Opcode = 51;
            DAL_Login.ReturnTable(pobj);
        }
    }
}