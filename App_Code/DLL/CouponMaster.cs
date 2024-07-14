using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DllUtility;
using System.Data.SqlClient;
using System.Data;
using System.EnterpriseServices;

namespace CouponMaster
{
    public class PL_CouponMaster : Utility
    {
        public string CouponCode { get; set; }
        public string StoreIdString { get; set; }
        public string CouponDescription { get; set; }
        public string CouponTerms { get; set; }
        public int CouponType { get; set; }
        public decimal Discount { get; set; }
        public decimal CouponAmount { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int Status { get; set; }
        public int UseStatus { get; set; }
        public int CouponAutoId { get; set; }

    }
    public class DAL_CoupanMaster
    {
        public static void ReturnTable(PL_CouponMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcCouponMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);
                sqlCmd.Parameters.AddWithValue("@CouponName", pobj.CouponDescription);
                sqlCmd.Parameters.AddWithValue("@CouponAutoId", pobj.CouponAutoId);
                sqlCmd.Parameters.AddWithValue("@CouponCode", pobj.CouponCode);
                sqlCmd.Parameters.AddWithValue("@StoreIdString", pobj.StoreIdString);
                sqlCmd.Parameters.AddWithValue("@CouponAmount", pobj.CouponAmount);
                sqlCmd.Parameters.AddWithValue("@TermsAndDescription", pobj.CouponTerms);
                sqlCmd.Parameters.AddWithValue("@CouponType", pobj.CouponType);
                sqlCmd.Parameters.AddWithValue("@Discount", pobj.Discount);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                if(pobj.StartDate>DateTime.MinValue && pobj.StartDate<DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@StartDate", pobj.StartDate);
                }
                if (pobj.EndDate > DateTime.MinValue && pobj.EndDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@EndDate", pobj.EndDate);
                }
                //sqlCmd.Parameters.AddWithValue("@EndDate", pobj.EndDate);
                sqlCmd.Parameters.AddWithValue("@Status", pobj.Status);
                sqlCmd.Parameters.AddWithValue("@UseStatus", pobj.UseStatus);
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
    public class BAL_CouponMaster
    {
        public static void AddCoupon(PL_CouponMaster pobj)
        {
            pobj.Opcode = 11;
            DAL_CoupanMaster.ReturnTable(pobj);
        }
        public static void BindCouponList(PL_CouponMaster pobj)
        {
            pobj.Opcode = 41;
            DAL_CoupanMaster.ReturnTable(pobj);
        }
        public static void DeleteCoupon(PL_CouponMaster pobj)
        {
            pobj.Opcode = 31;
            DAL_CoupanMaster.ReturnTable(pobj);
        }
        public static void editCoupon(PL_CouponMaster pobj)
        {
            pobj.Opcode = 42;
            DAL_CoupanMaster.ReturnTable(pobj);
        }
        public static void BindStoreList(PL_CouponMaster pobj)
        {
            pobj.Opcode = 43;
            DAL_CoupanMaster.ReturnTable(pobj);
        }
        public static void UpdateCoupon(PL_CouponMaster pobj)
        {
            pobj.Opcode = 21;
            DAL_CoupanMaster.ReturnTable(pobj);
        }
    }
}

   