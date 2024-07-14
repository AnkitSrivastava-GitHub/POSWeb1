using System;
using System.Data;
using System.Data.SqlClient;
using DllUtility;


namespace DLLChangeStore
{
    public class PL_ChangeStore : Utility
    {
        public int CompanyId { get; set; }
        public int EmployeeId { get; set; }
        public int LogInAutoId { get; set; }
    }
    public class DAL_ChangeStore
    {
        public static void ReturnTable(PL_ChangeStore pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcChangeStore", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@CompanyId", pobj.CompanyId);
                sqlCmd.Parameters.AddWithValue("@EmployeeId", pobj.EmployeeId);
                sqlCmd.Parameters.AddWithValue("@LogInAutoId", pobj.LogInAutoId);
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
    public class BAL_ChangeStore
    {
        public static void BindStoreList(PL_ChangeStore pobj)
        {
            pobj.Opcode = 41;
            DAL_ChangeStore.ReturnTable(pobj);
        }
        public static void ChangeStore(PL_ChangeStore pobj)
        {
            pobj.Opcode = 42;
            DAL_ChangeStore.ReturnTable(pobj);
        }
    }
}