using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;
using System.Reflection.Emit;
using System.Web.UI.WebControls;
using DllUtility;

public class DLLExpenseMaster
{
    public class PL_ExpenseMaster : Utility
    {
        public string ExpenseName { get; set; }
        public int Status { get; set; }
        public int ExpenseAutoId { get; set; }
        public int TerminalId { get; set;}
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }

    }
    public class DAL_Login
    {
        public static void ReturnTable(PL_ExpenseMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcExpenseMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@ExpenseName", pobj.ExpenseName);
                sqlCmd.Parameters.AddWithValue("@Status", pobj.Status);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                sqlCmd.Parameters.AddWithValue("@ExpenseAutoId", pobj.ExpenseAutoId);
                sqlCmd.Parameters.AddWithValue("@TerminalId", pobj.TerminalId);
                if (pobj.FromDate > DateTime.MinValue && pobj.FromDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@FromDate", pobj.FromDate);
                }
                if (pobj.ToDate > DateTime.MinValue && pobj.ToDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@ToDate", pobj.ToDate);
                }

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
    public class BAL_ExpenseMaster
    {
        public static void InsertExpense(PL_ExpenseMaster pobj)
        {
            pobj.Opcode = 11;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindExpenseList(PL_ExpenseMaster pobj)
        {
            pobj.Opcode = 42;
            DAL_Login.ReturnTable(pobj);
        }
        public static void DeleteExpense(PL_ExpenseMaster pobj)
        {
            pobj.Opcode = 31;
            DAL_Login.ReturnTable(pobj);
        }
        public static void editExpense(PL_ExpenseMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_Login.ReturnTable(pobj);
        }
        public static void UpdateExpense(PL_ExpenseMaster pobj)
        {
            pobj.Opcode = 21;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindExpenseTerminal(PL_ExpenseMaster pobj)
        {
            pobj.Opcode = 22;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindExpenseReport(PL_ExpenseMaster pobj)
        {
            pobj.Opcode = 23;
            DAL_Login.ReturnTable(pobj);
        }
    }
}
