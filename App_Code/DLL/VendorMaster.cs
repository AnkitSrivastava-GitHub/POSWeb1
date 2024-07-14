using System;
using System.Collections.Generic;
using System.Web;
using DllUtility;
using System.Data;
using System.Data.SqlClient;


namespace VendorMaster
{
    public  class PL_VendorMaster:Utility
    {
       public string VendorId { get; set; }
        public string VendorName { get; set; }
        public string Address { get; set; }
        public string Country { get; set; }
        public int State { get; set; }
        public string City { get; set; }
        public string ZipCode { get; set; }
        public string MobileNo { get; set; }
        public int VendorAutoId { get; set; }
        public string EmailId { get; set; }
        public string Status { get; set; }
        public string VendorCode { get; set; }
        public int CompanyId { get; set; }

    }
    public class DAL_Login
    {
        public static void ReturnTable(PL_VendorMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcVendorMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@opCode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@AutoId", pobj.VendorAutoId);
                sqlCmd.Parameters.AddWithValue("@VendorId", pobj.VendorId);
                sqlCmd.Parameters.AddWithValue("@VendorCode", pobj.VendorCode);
                sqlCmd.Parameters.AddWithValue("@CompanyId", pobj.CompanyId);
                sqlCmd.Parameters.AddWithValue("@VendorName", pobj.VendorName);
                sqlCmd.Parameters.AddWithValue("@Address", pobj.Address);
                sqlCmd.Parameters.AddWithValue("@Country", pobj.Country);
                sqlCmd.Parameters.AddWithValue("@City", pobj.City);
                sqlCmd.Parameters.AddWithValue("@State", pobj.State);
                sqlCmd.Parameters.AddWithValue("@ZipCode", pobj.ZipCode);
                sqlCmd.Parameters.AddWithValue("@MobileNo", pobj.MobileNo);
                sqlCmd.Parameters.AddWithValue("@EmailId", pobj.EmailId);
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
    public class BAL_VendorMaster
    {
        public static void InsertVendor(PL_VendorMaster pobj)
        {
            pobj.Opcode = 11;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindState(PL_VendorMaster pobj)
        {
            pobj.Opcode = 51;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindVendorList(PL_VendorMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_Login.ReturnTable(pobj);
        }
        public static void DeleteVendor(PL_VendorMaster pobj)
        {
            pobj.Opcode = 31;
            DAL_Login.ReturnTable(pobj);
        }
        public static void editVendorDetail(PL_VendorMaster pobj)
        {
            pobj.Opcode = 42;
            DAL_Login.ReturnTable(pobj);
        }
        public static void UpdateVendor(PL_VendorMaster pobj)
        {
            pobj.Opcode = 21;
            DAL_Login.ReturnTable(pobj);
        }
    }
}