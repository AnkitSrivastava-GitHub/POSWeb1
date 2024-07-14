using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using DllUtility;


namespace DLLTermAndConditionMaster
{
    public class PL_DLLTermAndConditionMaster:Utility
    {
       public int AutoId { get; set; }
        public string Terms { get; set; }
        public string OrderType { get; set; }
    }
    public class DAL_DLLTermAndConditionMaster
    {
        public static void ReturnTable(PL_DLLTermAndConditionMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand SqlCmd = new SqlCommand("ProcTermConditionMaster", connect.con);
                SqlCmd.CommandType = CommandType.StoredProcedure;
                SqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                SqlCmd.Parameters.AddWithValue("@AutoId", pobj.AutoId);
                SqlCmd.Parameters.AddWithValue("@Term", pobj.Terms);
                SqlCmd.Parameters.AddWithValue("@Type", pobj.OrderType);
                SqlCmd.Parameters.AddWithValue("@PageIndex", pobj.PageIndex);
                SqlCmd.Parameters.AddWithValue("@PageSize", pobj.PageSize);
                SqlCmd.Parameters.AddWithValue("@RecordCount", pobj.RecordCount);
                SqlCmd.Parameters.Add("@isException", SqlDbType.Bit);
                SqlCmd.Parameters["@isException"].Direction = ParameterDirection.Output;
                SqlCmd.Parameters.Add("@exceptionMessage", SqlDbType.VarChar, 500);
                SqlCmd.Parameters["@exceptionMessage"].Direction = ParameterDirection.Output;
                SqlDataAdapter sqlAdp = new SqlDataAdapter(SqlCmd);
                pobj.Ds = new DataSet();
                sqlAdp.Fill(pobj.Ds);
                pobj.isException = Convert.ToBoolean(SqlCmd.Parameters["@isException"].Value);
                pobj.exceptionMessage = SqlCmd.Parameters["@exceptionMessage"].Value.ToString();
            }
            catch(Exception ex)
            {
                pobj.isException = true;
                pobj.exceptionMessage = ex.Message;
            }
        }
    }
    public class BAL_DLLTermAndConditionMaster
    {
        public static void BindDropdowns(PL_DLLTermAndConditionMaster pobj)
        {
            pobj.Opcode = 51;
            DAL_DLLTermAndConditionMaster.ReturnTable(pobj);
        }
        public static void InsertTerms(PL_DLLTermAndConditionMaster pobj)
        {
            pobj.Opcode = 11;
            DAL_DLLTermAndConditionMaster.ReturnTable(pobj);
        }
        public static void BindTermsList(PL_DLLTermAndConditionMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_DLLTermAndConditionMaster.ReturnTable(pobj);
        }
        public static void DeleteTerms(PL_DLLTermAndConditionMaster pobj)
        {
            pobj.Opcode = 42;
            DAL_DLLTermAndConditionMaster.ReturnTable(pobj);
        }
        public static void EditTerms(PL_DLLTermAndConditionMaster pobj)
        {
            pobj.Opcode = 31;
            DAL_DLLTermAndConditionMaster.ReturnTable(pobj);
        }
        public static void UpdateTerms(PL_DLLTermAndConditionMaster pobj)
        {
            pobj.Opcode = 21;
            DAL_DLLTermAndConditionMaster.ReturnTable(pobj);
        }
    }
}