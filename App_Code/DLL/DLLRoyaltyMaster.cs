using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DllUtility;
using System.Data.SqlClient;
using System.Data;
using System.EnterpriseServices;

namespace DLLRoyaltyMaster
{
    public class PL_RoyaltyMaster : Utility
    {
        public int RoyaltyAutoId { get; set; }
        public decimal AmtPerRoyaltyPoint { get; set; }
        public decimal Amount { get; set; }
        public decimal MinOrderAmt { get; set; }
        public decimal MinOrderAmtForRoyalty { get; set; }
        public int RoyaltyStatus { get; set; }
        public int RoyaltyPoint { get; set; }
        public int AmtStatus { get; set; }
        public int AmtRoyaltyAutoId { get; set; }
       
    }
    public class DAL_RoyaltyMaster
    {
        public static void ReturnTable(PL_RoyaltyMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcRoyaltyMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;

                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@RoyaltyAutoId", pobj.RoyaltyAutoId);
                sqlCmd.Parameters.AddWithValue("@AmtPerRoyaltyPoint", pobj.AmtPerRoyaltyPoint);
                sqlCmd.Parameters.AddWithValue("@MinOrderAmt", pobj.MinOrderAmt);
                sqlCmd.Parameters.AddWithValue("@Status", pobj.RoyaltyStatus);
                sqlCmd.Parameters.AddWithValue("@AmtStatus", pobj.AmtStatus);
                sqlCmd.Parameters.AddWithValue("@Amount", pobj.Amount);
                sqlCmd.Parameters.AddWithValue("@RoyaltyPoint", pobj.RoyaltyPoint);
                sqlCmd.Parameters.AddWithValue("@AmtRoyaltyAutoId", pobj.AmtRoyaltyAutoId);
                sqlCmd.Parameters.AddWithValue("@MinOrderAmtForRoyalty", pobj.MinOrderAmtForRoyalty);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                
                sqlCmd.Parameters.AddWithValue("@Who", pobj.Who);
                sqlCmd.Parameters.AddWithValue("@PageIndex", pobj.PageIndex);
                sqlCmd.Parameters.AddWithValue("@PageSize", pobj.PageSize);
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
    public class BAL_RoyaltyMaster
    {
        public static void UpdateRoyalty(PL_RoyaltyMaster pobj)
        {
            pobj.Opcode =21;
            DAL_RoyaltyMaster.ReturnTable(pobj);
        }
        public static void UpdateAmtRoyalty(PL_RoyaltyMaster pobj)
        {
            pobj.Opcode =22;
            DAL_RoyaltyMaster.ReturnTable(pobj);
        }
        public static void BindRoyaltyList(PL_RoyaltyMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_RoyaltyMaster.ReturnTable(pobj);
        }
    }
}

