using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;
using System.Reflection.Emit;
using System.Web.UI.WebControls;
using DllUtility;

public class DLLCurrencyMaster
{
    public class PL_CurrencyMaster : Utility
    {
        public decimal Amount { get; set; }
        public int Status { get; set; }
        public int CurrencyAutoId { get; set; }


    }
    public class DAL_Login
    {
        public static void ReturnTable(PL_CurrencyMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcCurrencyMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@Amount", pobj.Amount);
                sqlCmd.Parameters.AddWithValue("@Status", pobj.Status);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                sqlCmd.Parameters.AddWithValue("@CurrencyAutoId", pobj.CurrencyAutoId);

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
    public class BAL_CurrencyMaster
    {
        public static void InsertCurrency(PL_CurrencyMaster pobj)
        {
            pobj.Opcode = 11;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindCurrencyList(PL_CurrencyMaster pobj)
        {
            pobj.Opcode = 42;
            DAL_Login.ReturnTable(pobj);
        }
        public static void DeleteCurrency(PL_CurrencyMaster pobj)
        {
            pobj.Opcode = 31;
            DAL_Login.ReturnTable(pobj);
        }
        public static void editCurrency(PL_CurrencyMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_Login.ReturnTable(pobj);
        }
        public static void UpdateCurrency(PL_CurrencyMaster pobj)
        {
            pobj.Opcode = 21;
            DAL_Login.ReturnTable(pobj);
        }
    }
}