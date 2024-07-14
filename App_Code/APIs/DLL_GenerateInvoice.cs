using DllUtility;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Activities.Validation;

namespace DLL_GenerateInvoice
{
    public class PL_GenerateInvoice : Utility
    {
        public int AutoId { get; set; }
        public int InvoiceAutoId { get; set; }
        public string LoginId { get; set; }
        public string InvoiceNo { get; set; }
        public string CustomerName { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public int OrderId { get; set; }
        public int CustomerId { get; set; }
        public string OrderNo { get; set; }
        public string CoupanNo { get; set; }
        public decimal CoupanAmt { get; set; }
        public string PaymentMethod { get; set; }
        public decimal Discount { get; set; }
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
    public class DAL_GenerateInvoice
    {
        public static void ReturnTable(PL_GenerateInvoice pobj)
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
                SqlCommand sqlCmd = new SqlCommand("ProcGenerateInvoiceAPI", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@LoginId", pobj.LoginId);
                sqlCmd.Parameters.AddWithValue("@AutoId", pobj.AutoId);
                sqlCmd.Parameters.AddWithValue("@InvoiceAutoId1", pobj.InvoiceAutoId);
                sqlCmd.Parameters.AddWithValue("@OrderId", pobj.OrderId);
                sqlCmd.Parameters.AddWithValue("@OrderNo", pobj.OrderNo);
                sqlCmd.Parameters.AddWithValue("@InvoiceNo1", pobj.InvoiceNo);
                sqlCmd.Parameters.AddWithValue("@CustomerName", pobj.CustomerName);
                if(pobj.FromDate>DateTime.MinValue && pobj.FromDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@FromDate", pobj.FromDate);
                }
                if (pobj.ToDate > DateTime.MinValue && pobj.ToDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@ToDate", pobj.ToDate);
                }
                sqlCmd.Parameters.AddWithValue("@CoupanNo", pobj.CoupanNo);
                sqlCmd.Parameters.AddWithValue("@CoupanAmt", pobj.CoupanAmt);
                sqlCmd.Parameters.AddWithValue("@CustomerId", pobj.CustomerId);
                sqlCmd.Parameters.AddWithValue("@Discount", pobj.Discount);
                sqlCmd.Parameters.AddWithValue("@PaymentMethod", pobj.PaymentMethod);
                sqlCmd.Parameters.AddWithValue("@URL", Scheme + HttpContext.Current.Request.Url.Authority);
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
    public class BAL_GenerateInvoice
    {
        public static void GenerateInvoice(PL_GenerateInvoice pobj)
        {
            pobj.Opcode = 11;
            DAL_GenerateInvoice.ReturnTable(pobj);
        }
        public static void InvoiceList(PL_GenerateInvoice pobj)
        {
            pobj.Opcode = 41;
            DAL_GenerateInvoice.ReturnTable(pobj);
        }
        public static void InvoiceDetail(PL_GenerateInvoice pobj)
        {
            pobj.Opcode = 42;
            DAL_GenerateInvoice.ReturnTable(pobj);
        }
    }
}