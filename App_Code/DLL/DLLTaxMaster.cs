using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;
using System.Reflection.Emit;
using System.Web.UI.WebControls;
using DllUtility;

namespace DLLTaxMaster
{
    public class PL_TaxMaster : Utility
    {
        public string TaxName { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxSPercentage { get; set; }
        public int Status { get; set; }
        public int TaxAutoId { get; set; }

    }
    public class DAL_Login
    {
        public static void ReturnTable(PL_TaxMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcTaxMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@TaxAutoId", pobj.TaxAutoId);
                sqlCmd.Parameters.AddWithValue("@TaxName", pobj.TaxName);
                sqlCmd.Parameters.AddWithValue("@TaxPercentage", pobj.TaxPercentage);
                sqlCmd.Parameters.AddWithValue("@TaxSPercentage", pobj.TaxSPercentage);
                sqlCmd.Parameters.AddWithValue("@Status", pobj.Status);
                //sqlCmd.Parameters.AddWithValue("@TaxAutoId", pobj.TaxAutoId);
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
    public class BAL_TaxMaster
    {
        public static void InsertTax(PL_TaxMaster pobj)
        {
            pobj.Opcode = 11;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindTaxList(PL_TaxMaster pobj)
        {
            pobj.Opcode = 42;
            DAL_Login.ReturnTable(pobj);
        }
        public static void DeleteTax(PL_TaxMaster pobj)
        {
            pobj.Opcode = 21;
            DAL_Login.ReturnTable(pobj);
        }
        public static void editTax(PL_TaxMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_Login.ReturnTable(pobj);
        }
        public static void UpdateTax(PL_TaxMaster pobj)
        {
            pobj.Opcode = 31;
            DAL_Login.ReturnTable(pobj);
        }
    }
}
