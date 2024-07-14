using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;
using System.Reflection.Emit;
using System.Web.UI.WebControls;
using DllUtility;
public class SubModule
{
    public class PL_SubModuleMaster : Utility
    {
        public string SubModuleURL { get; set; }
        public string SubModuleName { get; set; }
        public int ModuleId { get; set; }
        public int SubModuleAutoId { get; set; }    
        public int Status { get; set; }
        public int ModuleAutoId { get; set; }


    }

    public class DAL_Login
    {
        public static void ReturnTable(PL_SubModuleMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcSubModuleMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@ModuleId", pobj.ModuleId);
                sqlCmd.Parameters.AddWithValue("@SubModuleName", pobj.SubModuleName);
                sqlCmd.Parameters.AddWithValue("@SubModuleURL", pobj.SubModuleURL);
                sqlCmd.Parameters.AddWithValue("@Status", pobj.Status);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                sqlCmd.Parameters.AddWithValue("@SubModuleAutoId", pobj.SubModuleAutoId);

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
    public class BAL_SubModuleMaster
    {
        public static void InsertSubModule(PL_SubModuleMaster pobj)
        {
            pobj.Opcode = 11;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindSubModuleList(PL_SubModuleMaster pobj)
        {
            pobj.Opcode = 42;
            DAL_Login.ReturnTable(pobj);
        }
        public static void DeleteSubModule(PL_SubModuleMaster pobj)
        {
            pobj.Opcode = 31;
            DAL_Login.ReturnTable(pobj);
        }
        public static void editSubModule(PL_SubModuleMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_Login.ReturnTable(pobj);
        }
        public static void UpdateSubModule(PL_SubModuleMaster pobj)
        {
            pobj.Opcode = 21;
            DAL_Login.ReturnTable(pobj);
        }
        public static void BindDropDowns(PL_SubModuleMaster pobj)
        {
            pobj.Opcode = 51;
            DAL_Login.ReturnTable(pobj);
        }
    }
}