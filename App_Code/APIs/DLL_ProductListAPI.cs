using DllUtility;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Activities.Validation;

namespace DLL_ProductListAPI
{
    public class PL_ProductList : Utility
    {
        public int AutoId { get; set; }
        public string LoginId { get; set; }
        public string SearchString { get; set; }
        public int CategoryId { get; set; }
        public string ProductName { get; set; }
        public string Barcode { get; set; }
        public string Name { get; set; }
        public string MobileNo { get; set; }
        public string EmailId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Address { get; set; }
        public string State { get; set; }
        public string City { get; set; }
        public string ZipCode { get; set; }
        public DateTime DOB { get; set; }
        public int Fav { get; set; }
        public int Quantity { get; set; }
        public int BrandId { get; set; }
        public int ProductId { get; set; }
        public int SKUAutoId { get; set; }
        public string AccessToken { get; set; }
        public string Hashkey { get; set; }
        public string DeviceId { get; set; }
        public string LatLong { get; set; }
        public string AppVersion { get; set; }
        public string RequestSource { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public string NewPassword { get; set; }
    }
    public class DAL_ProductList
    {
        public static void ReturnTable(PL_ProductList pobj)
        {
            try
            {
                string host = HttpContext.Current.Request.Url.Host;
                string Scheme = "";
                if (host == "localhost")
                {
                     Scheme= "http://";
                }
                else
                {
                    Scheme = "https://";
                }
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcProductListAPI", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@LoginId", pobj.LoginId);
                sqlCmd.Parameters.AddWithValue("@SearchString", pobj.SearchString);
                sqlCmd.Parameters.AddWithValue("@ProductName", pobj.ProductName);
                sqlCmd.Parameters.AddWithValue("@Name", pobj.Name);
                sqlCmd.Parameters.AddWithValue("@MobileNo", pobj.MobileNo);
                sqlCmd.Parameters.AddWithValue("@FirstName", pobj.FirstName);
                sqlCmd.Parameters.AddWithValue("@LastName", pobj.LastName);
                sqlCmd.Parameters.AddWithValue("@Address", pobj.Address);
                sqlCmd.Parameters.AddWithValue("@State", pobj.State);
                sqlCmd.Parameters.AddWithValue("@City", pobj.City);
                sqlCmd.Parameters.AddWithValue("@ZipCode", pobj.ZipCode);
                sqlCmd.Parameters.AddWithValue("@EmailId", pobj.EmailId);
                if (pobj.DOB>DateTime.MinValue && pobj.DOB < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@EmailId", pobj.DOB);
                }
                sqlCmd.Parameters.AddWithValue("@CategoryId", pobj.CategoryId);
                sqlCmd.Parameters.AddWithValue("@BrandId", pobj.BrandId);
                sqlCmd.Parameters.AddWithValue("@URL", Scheme + HttpContext.Current.Request.Url.Authority);
                sqlCmd.Parameters.AddWithValue("@Fav", pobj.Fav);
                sqlCmd.Parameters.AddWithValue("@AutoId", pobj.AutoId);
                sqlCmd.Parameters.AddWithValue("@Quantity", pobj.Quantity);
                sqlCmd.Parameters.AddWithValue("@Barcode", pobj.Barcode);
                sqlCmd.Parameters.AddWithValue("@ProductId", pobj.ProductId);
                sqlCmd.Parameters.AddWithValue("@SKUAutoId", pobj.SKUAutoId);
                sqlCmd.Parameters.AddWithValue("@AccessToken", pobj.AccessToken);
                sqlCmd.Parameters.AddWithValue("@Hashkey", pobj.Hashkey);
                sqlCmd.Parameters.AddWithValue("@DeviceId", pobj.DeviceId);
                sqlCmd.Parameters.AddWithValue("@LatLong", pobj.LatLong);
                sqlCmd.Parameters.AddWithValue("@AppVersion", pobj.AppVersion);
                sqlCmd.Parameters.AddWithValue("@RequestSource", pobj.RequestSource);
                sqlCmd.Parameters.AddWithValue("@PageIndex", pobj.PageIndex);
                sqlCmd.Parameters.AddWithValue("@PageSize", pobj.PageSize);
                sqlCmd.Parameters.AddWithValue("@RecordCount", pobj.RecordCount);

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
    public class BAL_ProductListAPI
    {
       
        public static void GetProductList(PL_ProductList pobj)
        {
            pobj.Opcode = 41;
            DAL_ProductList.ReturnTable(pobj);
        }
        public static void GetCategoryList(PL_ProductList pobj)
        {
            pobj.Opcode = 42;
            DAL_ProductList.ReturnTable(pobj);
        }
        public static void GetBrandList(PL_ProductList pobj)
        {
            pobj.Opcode = 43;
            DAL_ProductList.ReturnTable(pobj);
        }
        public static void GetProductDetail(PL_ProductList pobj)
        {
            pobj.Opcode = 44;
            DAL_ProductList.ReturnTable(pobj);
        }
        public static void GetVarientDetail(PL_ProductList pobj)
        {
            pobj.Opcode = 45;
            DAL_ProductList.ReturnTable(pobj);
        }
        public static void GetCustomerList(PL_ProductList pobj)
        {
            pobj.Opcode = 46;
            DAL_ProductList.ReturnTable(pobj);
        }
        public static void CreateCustomer(PL_ProductList pobj)
        {
            pobj.Opcode = 47;
            DAL_ProductList.ReturnTable(pobj);
        }
    }
}