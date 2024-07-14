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

namespace DLLSchemeMaster
{
    public class PL_SchemeMaster : Utility
    {
        public int SchemeId { get; set; }
        public int SKUAutoId { get; set; }
        public int Quantity { get; set; }
        public decimal SchemePrice { get; set; }
        public string SchemeName { get; set; }
        public int Status { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public string SchemeDaysString { get; set; }
        public DataTable SchemeProductList { get; set; }

    }
    public class DAL_SchemeMaster
    {
        public static void ReturnTable(PL_SchemeMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcSchemeMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@who", pobj.Who);
                if (pobj.FromDate>DateTime.MinValue && pobj.FromDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@FromDate", pobj.FromDate);
                }
                if (pobj.ToDate > DateTime.MinValue && pobj.ToDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@ToDate", pobj.ToDate);
                }
                sqlCmd.Parameters.AddWithValue("@AutoId", pobj.SchemeId);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                sqlCmd.Parameters.AddWithValue("@SchemeDaysString", pobj.SchemeDaysString);
                sqlCmd.Parameters.AddWithValue("@SchemeName", pobj.SchemeName);
                sqlCmd.Parameters.AddWithValue("@SKUAutoId", pobj.SKUAutoId);
                sqlCmd.Parameters.AddWithValue("@Quantity", pobj.Quantity);
                sqlCmd.Parameters.AddWithValue("@UnitPrice", pobj.SchemePrice);
                sqlCmd.Parameters.AddWithValue("@Status", pobj.Status);
                sqlCmd.Parameters.AddWithValue("@DT_SchemeProduct", pobj.SchemeProductList);
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
    public class BAL_SchemeMaster
    {
        public static void InsertScheme(PL_SchemeMaster pobj)
        {
            pobj.Opcode = 11;
            DAL_SchemeMaster.ReturnTable(pobj);
        }
        public static void UpdateScheme(PL_SchemeMaster pobj)
        {
            pobj.Opcode = 21;
            DAL_SchemeMaster.ReturnTable(pobj);
        }
        public static void BindSchemedetail(PL_SchemeMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_SchemeMaster.ReturnTable(pobj);
        }
        public static void BindActiveSKU(PL_SchemeMaster pobj)
        {
            pobj.Opcode = 42;
            DAL_SchemeMaster.ReturnTable(pobj);
        }
        public static void GetSKUdetail(PL_SchemeMaster pobj)
        {
            pobj.Opcode = 43;
            DAL_SchemeMaster.ReturnTable(pobj);
        }
        public static void BindSchemeList(PL_SchemeMaster pobj)
        {
            pobj.Opcode = 44;
            DAL_SchemeMaster.ReturnTable(pobj);
        }
    }
}