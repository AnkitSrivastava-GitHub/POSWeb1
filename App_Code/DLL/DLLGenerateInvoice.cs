using System;
using System.Data.SqlClient;
using System.Data;
using DllUtility;

namespace DLLGenerateInvoice
{
    public class PL_GenerateInvoice : Utility
    {
        public string InvoiceNo { get; set; }
        public string SaleInvoice { get; set; }
        public int PoAutoId { get; set; }
        public int InvoiceId { get; set; }
        public int InvoiceItemId { get; set; }
        public int VendorAutoId { get; set; }
        public decimal CostPrice { get; set; }
        public string Vendor { get; set; }
        public string PoNumber { get; set; }
        public string BatchNo { get; set; } 
        public string Remark { get; set; }
        public int Status { get; set; }
        public DateTime PurchageDate { get; set; }
        public DataTable DT_InvoiceItem { get; set; }
    }
    public class DAL_GenerateInvoice
    {
        public static void ReturnTable(PL_GenerateInvoice pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcPurchaseInvoiceMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@PoNumber", pobj.PoNumber);
                sqlCmd.Parameters.AddWithValue("@Who", pobj.Who);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                sqlCmd.Parameters.AddWithValue("@BatchNo", pobj.BatchNo);
                sqlCmd.Parameters.AddWithValue("@VendorAutoId", pobj.VendorAutoId);
                sqlCmd.Parameters.AddWithValue("@InvoiceNo", pobj.InvoiceNo);
                sqlCmd.Parameters.AddWithValue("@SaleInvoice", pobj.SaleInvoice);
                sqlCmd.Parameters.AddWithValue("@InvoiceId", pobj.InvoiceId);
                sqlCmd.Parameters.AddWithValue("@InvoiceItemId", pobj.InvoiceItemId);
                sqlCmd.Parameters.AddWithValue("@Vendor", pobj.Vendor);
                sqlCmd.Parameters.AddWithValue("@PoAutoId", pobj.PoAutoId);
                sqlCmd.Parameters.AddWithValue("@CostPrice", pobj.CostPrice);
                if (pobj.PurchageDate > DateTime.MinValue && pobj.PurchageDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@PurchageDate", pobj.PurchageDate);
                }
                sqlCmd.Parameters.AddWithValue("@Remark", pobj.Remark);
                sqlCmd.Parameters.AddWithValue("@Status", pobj.Status);
                sqlCmd.Parameters.AddWithValue("@DT_InvoiceItem", pobj.DT_InvoiceItem);
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
    public class BAL_GenerateInvoice
    {
        public static void GenerateInvoice(PL_GenerateInvoice pobj)
        {
            pobj.Opcode = 11;
            DAL_GenerateInvoice.ReturnTable(pobj);
        }
        public static void DirectInvoiceGenerate(PL_GenerateInvoice pobj)
        {
            pobj.Opcode = 12;
            DAL_GenerateInvoice.ReturnTable(pobj);
        }
        public static void UpdateInvoice(PL_GenerateInvoice pobj)
        {
            pobj.Opcode = 21;
            DAL_GenerateInvoice.ReturnTable(pobj);
        }
        public static void DeleteInvoice(PL_GenerateInvoice pobj)
        {
            pobj.Opcode = 31;
            DAL_GenerateInvoice.ReturnTable(pobj);
        }
        public static void DeleteInvoiceItem(PL_GenerateInvoice pobj)
        {
            pobj.Opcode = 32;
            DAL_GenerateInvoice.ReturnTable(pobj);
        }
        public static void BindVendor(PL_GenerateInvoice pobj)
        {
            pobj.Opcode = 42;
            DAL_GenerateInvoice.ReturnTable(pobj);
        }
        public static void GetPODetail(PL_GenerateInvoice pobj)
        {
            pobj.Opcode = 41;
            DAL_GenerateInvoice.ReturnTable(pobj);
        }
        public static void BindInvoiceList(PL_GenerateInvoice pobj)
        {
            pobj.Opcode = 45;
            DAL_GenerateInvoice.ReturnTable(pobj);
        }
        public static void ViewInvoiceItem(PL_GenerateInvoice pobj)
        {
            pobj.Opcode = 46;
            DAL_GenerateInvoice.ReturnTable(pobj);
        }
        public static void editInvoiceDetail(PL_GenerateInvoice pobj)
        {
            pobj.Opcode = 47;
            DAL_GenerateInvoice.ReturnTable(pobj);
        }
        public static void ViewInvoiceItem2(PL_GenerateInvoice pobj)
        {
            pobj.Opcode = 48;
            DAL_GenerateInvoice.ReturnTable(pobj);
        }
        public static void ViewStockProduct(PL_GenerateInvoice pobj)
        {
            pobj.Opcode = 49;
            DAL_GenerateInvoice.ReturnTable(pobj);
        }
    }
}