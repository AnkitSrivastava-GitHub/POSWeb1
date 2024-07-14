using DllUtility;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Text;
using System.Threading.Tasks;

public class DLLLiveCart
{    
    public class PL_LiveCart : Utility
    {
        public int EmpId { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
    }
    public class DL_LiveCart
    {
        public static void Returntable(PL_LiveCart pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcLiveCartReport", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);

                sqlCmd.Parameters.AddWithValue("@EmpId", pobj.EmpId);
               
                sqlCmd.Parameters.AddWithValue("@TerminalId", pobj.TerminalId);
                sqlCmd.Parameters.AddWithValue("@PageIndex", pobj.PageIndex);
                sqlCmd.Parameters.AddWithValue("@PageSize", pobj.PageSize);
                sqlCmd.Parameters.AddWithValue("@RecordCount", pobj.RecordCount);
                sqlCmd.Parameters.AddWithValue("@Who", pobj.Who);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
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
    public class BL_LiveCart
    {
        public static void BindStore(PL_LiveCart pobj)
        {
            pobj.Opcode = 11;
            DL_LiveCart.Returntable(pobj);
        }
        public static void BindTerminal(PL_LiveCart pobj)
        {
            pobj.Opcode = 12;
            DL_LiveCart.Returntable(pobj);
        }
        public static void BindLiveCart(PL_LiveCart pobj)
        {
            pobj.Opcode = 13;
            DL_LiveCart.Returntable(pobj);
        }
        public static void SaleInvoiceList(PL_LiveCart pobj)
        {
            pobj.Opcode = 14;
            DL_LiveCart.Returntable(pobj);
        }
        public static void CurrencySymbol(PL_LiveCart pobj)
        {
            pobj.Opcode = 15;
            DL_LiveCart.Returntable(pobj);
        }
    }
}
