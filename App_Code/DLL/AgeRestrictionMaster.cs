using System;
using System.Collections.Generic;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using DllUtility;

namespace AgeRestrictionMaster
{
    public class PL_AgeRestrictionMaster:Utility
    {
       public int AutoId { get; set; }
        public int AgeId { get; set; }
        public string AgeRestrictionName { get; set; }
        public int Age { get; set; }
        public string SAge { get; set; }
    }
    public class DAL_Login
    {
        public static void ReturnTable(PL_AgeRestrictionMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcAgeRestriction", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
               // sqlCmd.Parameters.AddWithValue("@BrandId", pobj.AgeId);
                sqlCmd.Parameters.AddWithValue("@AgeRestrictionName", pobj.AgeRestrictionName);
                sqlCmd.Parameters.AddWithValue("@Age", pobj.Age);
                sqlCmd.Parameters.AddWithValue("@SAge", pobj.SAge);
                sqlCmd.Parameters.AddWithValue("@AgeRestrictionAutoId", pobj.AutoId);
                //sqlCmd.Parameters.AddWithValue("@Who", pobj.Who);
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

    public class BAL_AgeRestriction
    {
        public static void InsertAge(PL_AgeRestrictionMaster pobj)
        {
            pobj.Opcode = 11;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindAgeList(PL_AgeRestrictionMaster pobj)
        {
            pobj.Opcode = 42;
            DAL_Login.ReturnTable(pobj);
        }
        public static void DeleteAge(PL_AgeRestrictionMaster pobj)
        {
            pobj.Opcode = 31;
            DAL_Login.ReturnTable(pobj);
        }
        public static void editAge(PL_AgeRestrictionMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_Login.ReturnTable(pobj);
        }
        public static void UpdateAge(PL_AgeRestrictionMaster pobj)
        {
            pobj.Opcode = 21;
            DAL_Login.ReturnTable(pobj);
        }
    }
}