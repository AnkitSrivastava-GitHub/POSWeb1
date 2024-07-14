using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;
using System.Reflection.Emit;
using System.Web.UI.WebControls;
using DllUtility;

namespace DLLSKUMaster
{
    public class PL_SKUMaster : Utility
    {
        public int AutoId { get; set; }
        public string Image { get; set; }
        public string ProductId { get; set; }
        public string ProductName { get; set; }
        public string ProductSearchString { get; set; }
        public int BrandAutoId { get; set; }
        public int SKUAutoId { get; set; }
        public int VerificationCode { get; set; }
        public int CatgoryAutoId { get; set; }
        public int TaxId { get; set; }
        public int ProductAutoId { get; set; }
        public int PackingAutoId { get; set; }
        public decimal CostPrice { get; set; }
        public decimal SellingPrice { get; set; }
        public decimal Discount { get; set; }
        public decimal UnitPrice { get; set; }
        public int ManageStock { get; set; }
        public int InStock { get; set; }
        public int LowStock { get; set; }
        public string Barcode { get; set; }
        public string SKUId { get; set; }
        public string SKUName { get; set; }
        public string SKUProductDeletedIds { get; set; }
        public string SKUBarcodeDeletedIds { get; set; }
        public string Description { get; set; }
        public string PackingName { get; set; }
        public int AgeRestrictionId { get; set; }
        public int Status { get; set; }
        public DataTable SKUTable { get; set; }
        public DataTable BarcodeTable { get; set; }
        public DataTable DT_PakingType { get; set; }
        public DataTable DT_SKUProduct { get; set; }
        public DataTable DT_Barcode { get; set; }

    }
    public class DAL_SKUMaster
    {
        public static void ReturnTable(PL_SKUMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcSKUMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandTimeout = 10000;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@SKUAutoId",pobj.SKUAutoId);
                sqlCmd.Parameters.AddWithValue("@AutoId",pobj.AutoId);
                sqlCmd.Parameters.AddWithValue("@Who",pobj.Who);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                sqlCmd.Parameters.AddWithValue("@ProductAutoId",pobj.ProductAutoId);
                sqlCmd.Parameters.AddWithValue("@PackingAutoId",pobj.PackingAutoId);
                sqlCmd.Parameters.AddWithValue("@VerificationCode", pobj.VerificationCode);
                sqlCmd.Parameters.AddWithValue("@SKUId",pobj.SKUId);
                sqlCmd.Parameters.AddWithValue("@PackingName",pobj.PackingName);
                sqlCmd.Parameters.AddWithValue("@ProductSearchString", pobj.ProductSearchString);
                sqlCmd.Parameters.AddWithValue("@SellingPrice",pobj.SellingPrice);
                sqlCmd.Parameters.AddWithValue("@Barcode",pobj.Barcode);
                sqlCmd.Parameters.AddWithValue("@SKUName",pobj.SKUName);
                sqlCmd.Parameters.AddWithValue("@SKUProductDeletedIds", pobj.SKUProductDeletedIds);
                sqlCmd.Parameters.AddWithValue("@SKUBarcodeDeletedIds", pobj.SKUBarcodeDeletedIds);
                sqlCmd.Parameters.AddWithValue("@ProductName",pobj.SKUName);
                sqlCmd.Parameters.AddWithValue("@Image", pobj.Image);
                sqlCmd.Parameters.AddWithValue("@Description",pobj.Description);
                sqlCmd.Parameters.AddWithValue("@TaxId",pobj.TaxId);
                sqlCmd.Parameters.AddWithValue("@Status",pobj.Status);
                sqlCmd.Parameters.AddWithValue("@Discount",pobj.Discount);
                sqlCmd.Parameters.AddWithValue("@DT_SKUProduct",pobj.SKUTable);
                sqlCmd.Parameters.AddWithValue("@DT_Barcode", pobj.BarcodeTable);
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
    public class BAL_SKUMaster
    {
        public static void InsertSKU(PL_SKUMaster pobj)
        {
            pobj.Opcode = 11;
            DAL_SKUMaster.ReturnTable(pobj);
        }
        public static void BindProduct(PL_SKUMaster pobj)
        {
            pobj.Opcode = 12;
            DAL_SKUMaster.ReturnTable(pobj);
        }
        public static void BindUnitList(PL_SKUMaster pobj)
        {
            pobj.Opcode = 13;
            DAL_SKUMaster.ReturnTable(pobj);
        }
        public static void BindSKU(PL_SKUMaster pobj)
        {
            pobj.Opcode = 14;
            DAL_SKUMaster.ReturnTable(pobj);
        }
        public static void BindSKUDropdown(PL_SKUMaster pobj)
        {
            pobj.Opcode = 15;
            DAL_SKUMaster.ReturnTable(pobj);
        }
        public static void editSKUDetail(PL_SKUMaster pobj)
        {
            pobj.Opcode = 16;
            DAL_SKUMaster.ReturnTable(pobj);
        }
        public static void UpdateSKU(PL_SKUMaster pobj)
        {
            pobj.Opcode = 17;
            DAL_SKUMaster.ReturnTable(pobj);
        }
        public static void EditProductDetail(PL_SKUMaster pobj)
        {
            pobj.Opcode = 43;
            DAL_SKUMaster.ReturnTable(pobj);
        }
        public static void GetBarcodeList(PL_SKUMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_SKUMaster.ReturnTable(pobj);
        }
        public static void ValidateBarcode(PL_SKUMaster pobj)
        {
            pobj.Opcode = 44;
            DAL_SKUMaster.ReturnTable(pobj);
        }
    }
}