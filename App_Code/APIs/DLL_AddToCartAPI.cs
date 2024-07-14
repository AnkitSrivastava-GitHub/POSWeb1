using DllUtility;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;

namespace DLL_AddToCartAPI
{
    public class PL_AddToCart : Utility
    {
        public int AutoId { get; set; }
        public int CustomerId { get; set; }
        public int OrderId { get; set; }
        public string OrderNo { get; set; }
        public string SKUName { get; set; }
        public string LoginId { get; set; }
        public string Barcode { get; set; }
        public string Type { get; set; }
        public int Quantity { get; set; }
        public Decimal Discount { get; set; }
        public decimal SKUAmt { get; set; }
        public string GiftCardCode { get; set; }
        public int ProductId { get; set; }
        public int SKUAutoId { get; set; }
        public int CartItemId { get; set; }
        public int ShiftId { get; set; }
        public string AccessToken { get; set; }
        public string Hashkey { get; set; }
        public string DeviceId { get; set; }
        public string LatLong { get; set; }
        public string AppVersion { get; set; }
        public string RequestSource { get; set; }
        public string UserName { get; set; }
    }
    public class DAL_AddToCart
    {
        public static void ReturnTable(PL_AddToCart pobj)
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
                SqlCommand sqlCmd = new SqlCommand("ProcAddProductToCart", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@LoginId", pobj.LoginId);
                sqlCmd.Parameters.AddWithValue("@URL", Scheme + HttpContext.Current.Request.Url.Authority);
                sqlCmd.Parameters.AddWithValue("@AutoId", pobj.AutoId);
                sqlCmd.Parameters.AddWithValue("@OrderId", pobj.OrderId);
                sqlCmd.Parameters.AddWithValue("@OrderNo", pobj.OrderNo);
                sqlCmd.Parameters.AddWithValue("@Discount", pobj.Discount);
                sqlCmd.Parameters.AddWithValue("@Quantity", pobj.Quantity);
                sqlCmd.Parameters.AddWithValue("@Barcode", pobj.Barcode);
                sqlCmd.Parameters.AddWithValue("@CartItemId", pobj.CartItemId);
                sqlCmd.Parameters.AddWithValue("@ProductId", pobj.ProductId);
                sqlCmd.Parameters.AddWithValue("@CustomerId", pobj.CustomerId);
                sqlCmd.Parameters.AddWithValue("@SKUId", pobj.SKUAutoId);
                sqlCmd.Parameters.AddWithValue("@AccessToken", pobj.AccessToken);
                sqlCmd.Parameters.AddWithValue("@Hashkey", pobj.Hashkey);
                sqlCmd.Parameters.AddWithValue("@DeviceId", pobj.DeviceId);
                sqlCmd.Parameters.AddWithValue("@LatLong", pobj.LatLong);
                sqlCmd.Parameters.AddWithValue("@AppVersion", pobj.AppVersion);
                sqlCmd.Parameters.AddWithValue("@RequestSource", pobj.RequestSource);
                sqlCmd.Parameters.AddWithValue("@RecordCount", pobj.RecordCount);
                sqlCmd.Parameters.AddWithValue("@SKUName", pobj.SKUName);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                sqlCmd.Parameters.AddWithValue("@TerminalId", pobj.TerminalId);
                sqlCmd.Parameters.AddWithValue("@SKUAmt", pobj.SKUAmt);
                sqlCmd.Parameters.AddWithValue("@GiftCardCode", pobj.GiftCardCode);
                sqlCmd.Parameters.AddWithValue("@Type", pobj.Type);
                sqlCmd.Parameters.AddWithValue("@ShiftId", pobj.ShiftId);

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
    public class BAL_AddToCartAPI
    {
        public static void AddProductToCart(PL_AddToCart pobj)
        {
            pobj.Opcode = 41;
            DAL_AddToCart.ReturnTable(pobj);
        }
        public static void ApplyDiscount(PL_AddToCart pobj)
        {
            pobj.Opcode = 21;
            DAL_AddToCart.ReturnTable(pobj);
        }
        public static void GetCartDetails(PL_AddToCart pobj)
        {
            pobj.Opcode = 22;
            DAL_AddToCart.ReturnTable(pobj);
        }
        public static void ResetCartDetails(PL_AddToCart pobj)
        {
            pobj.Opcode = 23;
            DAL_AddToCart.ReturnTable(pobj);
        }
    }
}
