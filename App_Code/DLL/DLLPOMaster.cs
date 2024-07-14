using System;
using System.Data.SqlClient;
using System.Data;
using DllUtility;

namespace DLLPOMaster
{
    public class PL_POMaster : Utility
    {
        public int ProductAutoId { get; set; }
        public int PackingAutoId { get; set; }
        public int PoAutoId { get; set; }
        public int VendorAutoId { get; set; }
        public int ProductUnitId { get; set; }
        public string VenderProductCode { get; set; }
        public string Barcode { get; set; }
        public string Vendor { get; set; }
        public string PoNumber { get; set; }
        public string Remark { get; set; }
        public int Status { get; set; }
        public string Status1 { get; set; }
        public DateTime PoDate { get; set; }
        public DataTable DT_PoItemMasert { get; set; }
    }
    public class DAL_POMaster
    {
        public static void ReturnTable(PL_POMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcPoMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@PoNumber", pobj.PoNumber);
                sqlCmd.Parameters.AddWithValue("@Who", pobj.Who);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                sqlCmd.Parameters.AddWithValue("@ProductAutoId", pobj.ProductAutoId);
                sqlCmd.Parameters.AddWithValue("@PackingAutoId", pobj.PackingAutoId);
                sqlCmd.Parameters.AddWithValue("@VendorAutoId", pobj.VendorAutoId);
                sqlCmd.Parameters.AddWithValue("@VenderProductCode", pobj.VenderProductCode);
                sqlCmd.Parameters.AddWithValue("@Vendor", pobj.Vendor);
                sqlCmd.Parameters.AddWithValue("@PoAutoId", pobj.PoAutoId);
                sqlCmd.Parameters.AddWithValue("@ProductUnitId", pobj.ProductUnitId);
                sqlCmd.Parameters.AddWithValue("@Barcode", pobj.Barcode);
                if (pobj.PoDate > DateTime.MinValue && pobj.PoDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@PoDate", pobj.PoDate);
                }
                sqlCmd.Parameters.AddWithValue("@Remark", pobj.Remark);
                sqlCmd.Parameters.AddWithValue("@Status", pobj.Status);
                sqlCmd.Parameters.AddWithValue("@Status1", pobj.Status1);
                sqlCmd.Parameters.AddWithValue("@DT_PoItemMasert", pobj.DT_PoItemMasert);
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
    public class BAL_POMaster
    {
        public static void InsertPO(PL_POMaster pobj)
        {
            pobj.Opcode = 11;
            DAL_POMaster.ReturnTable(pobj);
        }
        public static void UpdatePO(PL_POMaster pobj)
        {
            pobj.Opcode = 21;
            DAL_POMaster.ReturnTable(pobj);
        }
        public static void DeletePO(PL_POMaster pobj)
        {
            pobj.Opcode = 31;
            DAL_POMaster.ReturnTable(pobj);
        }
        public static void BindProduct(PL_POMaster pobj)
        {
            pobj.Opcode = 42;
            DAL_POMaster.ReturnTable(pobj);
        }
        public static void BindVendor(PL_POMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_POMaster.ReturnTable(pobj);
        }
        public static void BindUnitList(PL_POMaster pobj)
        {
            pobj.Opcode = 43;
            DAL_POMaster.ReturnTable(pobj);
        }
        public static void editPODetail(PL_POMaster pobj)
        {
            pobj.Opcode = 44;
            DAL_POMaster.ReturnTable(pobj);
        }
        public static void BindPOList(PL_POMaster pobj)
        {
            pobj.Opcode = 45;
            DAL_POMaster.ReturnTable(pobj);
        }
        public static void ViewPOItem(PL_POMaster pobj)
        {
            pobj.Opcode = 46;
            DAL_POMaster.ReturnTable(pobj);
        }
        public static void FillProductByVendor(PL_POMaster pobj)
        {
            pobj.Opcode = 47;
            DAL_POMaster.ReturnTable(pobj);
        }
        public static void FillProductByBarcode(PL_POMaster pobj)
        {
            pobj.Opcode = 49;
            DAL_POMaster.ReturnTable(pobj);
        }
        public static void BindUnitPrice(PL_POMaster pobj)
        {
            pobj.Opcode = 48;
            DAL_POMaster.ReturnTable(pobj);
        }
    }
}