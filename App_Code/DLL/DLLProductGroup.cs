using DllUtility;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;

namespace DLLProductGroup
{
    public class PL_ProductGroup : Utility
    {
        public string GroupName { get; set; }
        public int GroupId { get; set; }
        public int DepartmentId { get; set; }
        public int Status { get; set; }
        public int Quantity { get; set; }
        public int DiscountCriteria { get; set; }
        public decimal DiscountValue { get; set; }
        public int CategoryId { get; set; }
        public int SKUId { get; set; }
        public DataTable ProductGroupTable { get; set; }
    }
    public class DAL_ProductGroup
    {
        public static void ReturnTable(PL_ProductGroup pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcProductGrouping", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@who", pobj.Who);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                sqlCmd.Parameters.AddWithValue("@GroupName", pobj.GroupName);
                sqlCmd.Parameters.AddWithValue("@MixNMatchId", pobj.GroupId);
                sqlCmd.Parameters.AddWithValue("@Status", pobj.Status);
                sqlCmd.Parameters.AddWithValue("@Quantity", pobj.Quantity);
                sqlCmd.Parameters.AddWithValue("@DiscountCriteria", pobj.DiscountCriteria);
                sqlCmd.Parameters.AddWithValue("@DiscountValue", pobj.DiscountValue);
                sqlCmd.Parameters.AddWithValue("@ProductGroupTable", pobj.ProductGroupTable);
                sqlCmd.Parameters.AddWithValue("@DepartmentId", pobj.DepartmentId);
                sqlCmd.Parameters.AddWithValue("@CategoryId", pobj.CategoryId);
                sqlCmd.Parameters.AddWithValue("@SKUId", pobj.SKUId);
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
    public class BAL_ProductGroup
    {
        public static void InsertProductGroup(PL_ProductGroup pobj)
        {
            pobj.Opcode = 11;
            DAL_ProductGroup.ReturnTable(pobj);
        }
        public static void UpdateProductGroup(PL_ProductGroup pobj)
        {
            pobj.Opcode = 21;
            DAL_ProductGroup.ReturnTable(pobj);
        }
        public static void DeleteGroup(PL_ProductGroup pobj)
        {
            pobj.Opcode = 31;
            DAL_ProductGroup.ReturnTable(pobj);
        }
        public static void BindDropDown(PL_ProductGroup pobj)
        {
            pobj.Opcode = 41;
            DAL_ProductGroup.ReturnTable(pobj);
        }
        public static void CreateMixMatchTable(PL_ProductGroup pobj)
        {
            pobj.Opcode = 42;
            DAL_ProductGroup.ReturnTable(pobj);
        }
        public static void BindMixNMatchList(PL_ProductGroup pobj)
        {
            pobj.Opcode = 43;
            DAL_ProductGroup.ReturnTable(pobj);
        }
        public static void BindMixNMatchItemList(PL_ProductGroup pobj)
        {
            pobj.Opcode = 44;
            DAL_ProductGroup.ReturnTable(pobj);
        }
        public static void editGroupDetail(PL_ProductGroup pobj)
        {
            pobj.Opcode = 45;
            DAL_ProductGroup.ReturnTable(pobj);
        }
    }
}