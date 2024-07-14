using System;
using System.Collections.Generic;
using System.Web;
using System.Configuration;
using DllUtility;
using System.Data;
using System.Data.SqlClient;

namespace DLLCompanyProfile
{
    public class PL_CompanyProfile: Utility
    {
        public int companyId { get; set; }
        public string CompanyName { get; set; }
        public string Billingaddress { get; set; }
        public string ContactPerson { get; set; }
        public string City { get; set; }
        public string country { get; set; }
        public string state { get; set; }
        public string ZipCode { get; set; }
        public string EmailId { get; set; }
        public string Website { get; set; }
        public string phoneno { get; set; }
        public string mobileNo { get; set; }
        public string Faxno { get; set; }
        public string Vatno {get; set; }
        public int AutoId { get; set; }
        public int status { get; set; }
        public int CurrencyId { get; set; }
        public int AllowLottoSale { get; set; }
        public string CLogo { get; set; }
    }
    public class DA_CompanyMaster
    {
        public static void ReturnTable(PL_CompanyProfile pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand SqlCmd = new SqlCommand("ProcCompanyProfile", connect.con);
                SqlCmd.CommandTimeout = 10000;
                SqlCmd.CommandType = CommandType.StoredProcedure;
                SqlCmd.Parameters.AddWithValue("@AutoId", pobj.AutoId);
                SqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                SqlCmd.Parameters.AddWithValue("@CompanyName", pobj.CompanyName);
                SqlCmd.Parameters.AddWithValue("@ContactName", pobj.ContactPerson);
                SqlCmd.Parameters.AddWithValue("@BillingAddress", pobj.Billingaddress);
                SqlCmd.Parameters.AddWithValue("@Country", pobj.country);
                SqlCmd.Parameters.AddWithValue("@State", pobj.state);
                SqlCmd.Parameters.AddWithValue("@City", pobj.City);
                SqlCmd.Parameters.AddWithValue("@ZipCode", pobj.ZipCode);
                SqlCmd.Parameters.AddWithValue("@EmailId", pobj.EmailId);
                SqlCmd.Parameters.AddWithValue("@Website", pobj.Website);
                SqlCmd.Parameters.AddWithValue("@TeliPhoneNo", pobj.mobileNo);
                SqlCmd.Parameters.AddWithValue("@PhoneNo", pobj.phoneno);
                SqlCmd.Parameters.AddWithValue("@FaxNo", pobj.Faxno);
                SqlCmd.Parameters.AddWithValue("@VatNo", pobj.Vatno);
                SqlCmd.Parameters.AddWithValue("@status", pobj.status);
                SqlCmd.Parameters.AddWithValue("@CurrencyId", pobj.CurrencyId);
                SqlCmd.Parameters.AddWithValue("@AllowLottoSale", pobj.AllowLottoSale);
                SqlCmd.Parameters.AddWithValue("@CLogo", pobj.CLogo);
                SqlCmd.Parameters.AddWithValue("@Who", pobj.Who);
                SqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                SqlCmd.Parameters.AddWithValue("@PageIndex", pobj.PageIndex);
                SqlCmd.Parameters.AddWithValue("@PageSize", pobj.PageSize);
                SqlCmd.Parameters.AddWithValue("@RecordCount", pobj.RecordCount);
                SqlCmd.Parameters.Add("@isException", SqlDbType.Bit);
                SqlCmd.Parameters["@isException"].Direction = ParameterDirection.Output;
                SqlCmd.Parameters.Add("@exceptionMessage", SqlDbType.VarChar, 500);
                SqlCmd.Parameters["@exceptionMessage"].Direction = ParameterDirection.Output;
                SqlDataAdapter sqlAdp = new SqlDataAdapter(SqlCmd);
                pobj.Ds = new DataSet();
                sqlAdp.Fill(pobj.Ds);
                pobj.isException = Convert.ToBoolean(SqlCmd.Parameters["@isException"].Value);
                pobj.exceptionMessage = SqlCmd.Parameters["@exceptionMessage"].Value.ToString();
            }
            catch( Exception ex)
            {
                pobj.isException = true;
                pobj.exceptionMessage = ex.Message;
            }


        }
    }
    public class BAL_CompanyProfile
    {
        public static void InsertStore(PL_CompanyProfile pobj)
        {
            pobj.Opcode = 11;
            DA_CompanyMaster.ReturnTable(pobj);
        }
        public static void editCompanyProfile(PL_CompanyProfile pobj)
        {
            pobj.Opcode =41;
            DA_CompanyMaster.ReturnTable(pobj);
        }
        public static void updateCompanyProfile(PL_CompanyProfile pobj)
        {
            pobj.Opcode = 21;
            DA_CompanyMaster.ReturnTable(pobj);
        }
        public static void BindStoreList(PL_CompanyProfile pobj)
        {
            pobj.Opcode = 43;
            DA_CompanyMaster.ReturnTable(pobj);
        }
        public static void DeleteStore(PL_CompanyProfile pobj)
        {
            pobj.Opcode = 31;
            DA_CompanyMaster.ReturnTable(pobj);
        }
        public static void bindCurrency(PL_CompanyProfile pobj)
        {
            pobj.Opcode = 32;
            DA_CompanyMaster.ReturnTable(pobj);
        }
    }
}
