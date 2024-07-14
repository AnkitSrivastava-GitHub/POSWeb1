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

namespace DLLProductMaster
{
    public class PL_ProductMaster : Utility
    {
        public int AutoId { get; set; }
        public int VendorId { get; set; }
        public string Image { get; set; }
        public string VendorProductCode { get; set; }
        public int ViewImage { get; set; }
        public int VerificationCode { get; set; }
        public int DeptId { get; set; }
        public int NoOfPieces { get; set; }
        public string PieceSize { get; set; }
        public string BarcodeForEdit { get; set; }
        public string MeasurementUnit { get; set; }
        public int MeasurementUnitId { get; set; }
        public decimal SecondaryUnitPrice { get; set; }
        public string ImageName { get; set; }
        public string WebAvailability { get; set; }
        public int ProductAutoId { get; set; }
        public string ProductId { get; set; }
        public string ProductName { get; set; }
        public string ProductShortName { get; set; }
        public string Packing { get; set; }
        public string ProductSize { get; set; }
        public int BrandAutoId { get; set; }
        public int CatgoryAutoId { get; set; }
        public int TaxAutoId { get; set; }
        public int GroupId { get; set; }
        public int InStockQty { get; set; }
        public int AlertQty { get; set; }
        public decimal CostPrice { get; set; }
        public decimal UnitPrice { get; set; }
        public int ManageStock { get; set; }
        public int InStock { get; set; }
        public int LowStock { get; set; }
        public string Barcode { get; set; }
        public int AgeRestrictionId { get; set; }
        public int Status { get; set; }
        public string Description { get; set; }
        public string StoreIdsList { get; set; }
        public string ProductIdsList { get; set; }
        public DataTable DT_PakingType { get; set; }
        public DataTable DT_VendorProductCode { get; set; }
        public DataTable DT_Barcode { get; set; }

    }
    public class DAL_ProductMaster
    {
        public static void ReturnTable(PL_ProductMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcProductMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandTimeout = 10000;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);

                sqlCmd.Parameters.AddWithValue("@AutoId", pobj.AutoId);
                sqlCmd.Parameters.AddWithValue("@ProductAutoId", pobj.ProductAutoId);
                sqlCmd.Parameters.AddWithValue("@Image", pobj.Image);
                sqlCmd.Parameters.AddWithValue("@ViewImage", pobj.ViewImage);
                sqlCmd.Parameters.AddWithValue("@VendorId", pobj.VendorId);
                sqlCmd.Parameters.AddWithValue("@VendorProductCode", pobj.VendorProductCode);

                sqlCmd.Parameters.AddWithValue("@ProductSize", pobj.ProductSize);
                sqlCmd.Parameters.AddWithValue("@GroupId", pobj.GroupId);
             
                sqlCmd.Parameters.AddWithValue("@InStockQty", pobj.InStockQty);
                sqlCmd.Parameters.AddWithValue("@AlertQty", pobj.AlertQty);

                sqlCmd.Parameters.AddWithValue("@NoOfPieces", pobj.NoOfPieces);
                sqlCmd.Parameters.AddWithValue("@PieceSize", pobj.PieceSize);
                sqlCmd.Parameters.AddWithValue("@SecondaryUnitPrice", pobj.SecondaryUnitPrice);
                sqlCmd.Parameters.AddWithValue("@ImageName", pobj.ImageName);
                sqlCmd.Parameters.AddWithValue("@WebAvailability", pobj.WebAvailability);
                sqlCmd.Parameters.AddWithValue("@MeasurementUnit", pobj.MeasurementUnit);
                sqlCmd.Parameters.AddWithValue("@MeasurementUnitId", pobj.MeasurementUnitId);

                sqlCmd.Parameters.AddWithValue("@ProductName", pobj.ProductName);
                sqlCmd.Parameters.AddWithValue("@ProductShortName", pobj.ProductShortName);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                sqlCmd.Parameters.AddWithValue("@Packing", pobj.Packing);
                sqlCmd.Parameters.AddWithValue("@Description", pobj.Description);
                sqlCmd.Parameters.AddWithValue("@BrandAutoId", pobj.BrandAutoId);
                sqlCmd.Parameters.AddWithValue("@DeptId", pobj.DeptId);
                sqlCmd.Parameters.AddWithValue("@CatgoryAutoId", pobj.CatgoryAutoId);
                sqlCmd.Parameters.AddWithValue("@TaxAutoId", pobj.TaxAutoId);
                sqlCmd.Parameters.AddWithValue("@CostPrice", pobj.CostPrice);
                sqlCmd.Parameters.AddWithValue("@VerificationCode", pobj.VerificationCode);
                sqlCmd.Parameters.AddWithValue("@UnitPrice", pobj.UnitPrice);
                sqlCmd.Parameters.AddWithValue("@ManageStock", pobj.ManageStock);
                sqlCmd.Parameters.AddWithValue("@InStock", pobj.InStock);
                sqlCmd.Parameters.AddWithValue("@LowStock", pobj.LowStock);
                sqlCmd.Parameters.AddWithValue("@Barcode", pobj.Barcode);
                sqlCmd.Parameters.AddWithValue("@BarcodeForEdit", pobj.BarcodeForEdit);

                sqlCmd.Parameters.AddWithValue("@StoreIdsString", pobj.StoreIdsList);
                sqlCmd.Parameters.AddWithValue("@ProductIdsList", pobj.ProductIdsList);
                sqlCmd.Parameters.AddWithValue("@AgeRestrictionId", pobj.AgeRestrictionId);

                sqlCmd.Parameters.AddWithValue("@DT_PakingType", pobj.DT_PakingType);
                sqlCmd.Parameters.AddWithValue("@DT_VendorProductCode", pobj.DT_VendorProductCode);
                sqlCmd.Parameters.AddWithValue("@DT_Barcode", pobj.DT_Barcode);

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
    public class BAL_ProductMaster
    {
        public static void InsertProduct(PL_ProductMaster pobj)
        {
            pobj.Opcode = 11;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void AddPacking(PL_ProductMaster pobj)
        {
            pobj.Opcode = 12;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void AddVendorInDB(PL_ProductMaster pobj)
        {
            pobj.Opcode = 13;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void AddBarcodeInDB(PL_ProductMaster pobj)
        {
            pobj.Opcode = 14;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void ChangeInBulk(PL_ProductMaster pobj)
        {
            pobj.Opcode = 15;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void UpdateProduct(PL_ProductMaster pobj)
        {
            pobj.Opcode = 21;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void UpdatePacking(PL_ProductMaster pobj)
        {
            pobj.Opcode = 22;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void ChangeProductStatus(PL_ProductMaster pobj)
        {
            pobj.Opcode = 23;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void UpdateProductVendorInDB(PL_ProductMaster pobj)
        {
            pobj.Opcode = 24;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void UpdateBarcodeInDB(PL_ProductMaster pobj)
        {
            pobj.Opcode = 25;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void DeletePacking(PL_ProductMaster pobj)
        {
            pobj.Opcode = 31;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void DeleteVendorProductFromDB(PL_ProductMaster pobj)
        {
            pobj.Opcode = 32;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void DeleteBarcodeInDB(PL_ProductMaster pobj)
        {
            pobj.Opcode = 33;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void BindProductList(PL_ProductMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void BindMaster(PL_ProductMaster pobj)
        {
            pobj.Opcode = 42;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void EditProductDetail(PL_ProductMaster pobj)
        {
            pobj.Opcode = 43;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void EditPacking(PL_ProductMaster pobj)
        {
            pobj.Opcode = 44;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void ValidateBarcode(PL_ProductMaster pobj)
        {
            pobj.Opcode = 45;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void BindStoreList(PL_ProductMaster pobj)
        {
            pobj.Opcode = 46;
            DAL_ProductMaster.ReturnTable(pobj);
        }
        public static void BindAgeRestriction(PL_ProductMaster pobj)
        {
            pobj.Opcode = 47;
            DAL_ProductMaster.ReturnTable(pobj);
        } 
        public static void ValidateVendorProductCode(PL_ProductMaster pobj)
        {
            pobj.Opcode = 48;
            DAL_ProductMaster.ReturnTable(pobj);
        }
    }
}