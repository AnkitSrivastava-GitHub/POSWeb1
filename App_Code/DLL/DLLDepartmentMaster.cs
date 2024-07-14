using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DllUtility;
using System.Data;
using System.Data.SqlClient;


namespace DLLDepartmentMaster
{
    public class PL_DepartmentMaster : Utility
    {
        public string DepartmentName { get; set; }
        public int Status { get; set; }
        public int DepartmentAutoId { get; set; }
        public string DepartmentId { get; set; }
        public int AgeRestrictionId { get; set; }
    }
    public class DAL_Login
    {
        public static void ReturnTable(PL_DepartmentMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcDepartmentMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@DepartmentId", pobj.DepartmentId);
                sqlCmd.Parameters.AddWithValue("@DepartmentName", pobj.DepartmentName);
                sqlCmd.Parameters.AddWithValue("@DepartmentAutoId", pobj.DepartmentAutoId);
                sqlCmd.Parameters.AddWithValue("@Status", pobj.Status);
                sqlCmd.Parameters.AddWithValue("@AgeRestrictionId", pobj.AgeRestrictionId);
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
    public class BAL_DepartmentMaster
    {
        public static void BindDropDowns(PL_DepartmentMaster pobj)
        {
            pobj.Opcode = 45;
            DAL_Login.ReturnTable(pobj);
        }
        public static void InsertDepartment(PL_DepartmentMaster pobj)
        {
            pobj.Opcode = 11;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindDepartmentList(PL_DepartmentMaster pobj)
        {
            pobj.Opcode = 42;
            DAL_Login.ReturnTable(pobj);
        }
        public static void DeleteDepartment(PL_DepartmentMaster pobj)
        {
            pobj.Opcode = 21;
            DAL_Login.ReturnTable(pobj);
        }
        public static void editDepartment(PL_DepartmentMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_Login.ReturnTable(pobj);
        }
        public static void UpdateDepartment(PL_DepartmentMaster pobj)
        {
            pobj.Opcode = 31;
            DAL_Login.ReturnTable(pobj);
        }
    }
}