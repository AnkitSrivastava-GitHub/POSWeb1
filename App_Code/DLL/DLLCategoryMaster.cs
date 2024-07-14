using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;
using System.Reflection.Emit;
using System.Web.UI.WebControls;
using DllUtility;

namespace DLLCategoryMaster
{
    public class PL_CategoryMaster : Utility
    {
        public int ddlcategory { get; set; }
        public string CategoryName { get; set; }
        public int Status { get; set; }
        public int CategoryAutoId { get; set; }
       

    }
    public class DAL_Login
    {
        public static void ReturnTable(PL_CategoryMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcCategoryMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@CategoryName", pobj.CategoryName);
                sqlCmd.Parameters.AddWithValue("@Status", pobj.Status);
                sqlCmd.Parameters.AddWithValue("@CategoryAutoId", pobj.CategoryAutoId);
                
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
    public class BAL_CategoryMaster
    {
        public static void InsertCategory(PL_CategoryMaster pobj)
        {
            pobj.Opcode = 11;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindCategoryList(PL_CategoryMaster pobj)
        {
            pobj.Opcode = 42;
            DAL_Login.ReturnTable(pobj);
        }
        public static void DeleteCategory(PL_CategoryMaster pobj)
        {
            pobj.Opcode = 31;
            DAL_Login.ReturnTable(pobj);
        }
        public static void editCategory(PL_CategoryMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_Login.ReturnTable(pobj);
        }
        public static void UpdateCategory(PL_CategoryMaster pobj)
        {
            pobj.Opcode = 21;
            DAL_Login.ReturnTable(pobj);
        }
    }
}
