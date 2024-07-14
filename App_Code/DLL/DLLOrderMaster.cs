using DllUtility;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace DLLOrderMaster
{
    public class PL_orderMaster : Utility
    {
        public int UserTypeId { get; set; }
        public int CardTypeId { get; set; }
        public int BrandAutoId { get; set; }
        public int CategoryAutoId { get; set; }
        public int BalanceAutoId { get; set; }
        public int TerminalId { get; set; }
        public string PaymentMethod { get; set; }
        public string SecuirtyCode { get; set; }
        public string BalanceStatus { get; set; }
        public decimal OpeningBalance { get; set; }
        public decimal CurrentBalance { get; set; }
        public string CurrentBalStatus { get; set; }
        public decimal ClosingBalance { get; set; }
        public DataTable CurrencyTable { get; set; }
        public decimal PaidAmount { get; set; }
        public string TempInvoiceNo { get; set; }
        public string TransactionId { get; set; }
        public string CreditCardLastFourDigits { get; set; }
        public string AuthCode { get; set; }
        public int SKUAutoId { get; set; }
        public string Product { get; set; }
        public int ProductAutoId { get; set; }
        public string CreatedFrom { get; set; }
        public string Type { get; set; }
        public int PackingAutoId { get; set; }
        public string CategoryId { get; set; }
        public int Fav { get; set; }
        public int Quantity { get; set; }
        public int MinAge { get; set; }
        public string ScreenName { get; set; }
        public int Status { get; set; }
        public string TrnsStatus { get; set; }
        public int ScreenId { get; set; }
        public string CouponCode { get; set; }
        public decimal TotalAmt { get; set; }
        public int SchemeId { get; set; }
        public string Barcode { get; set; }
        public DataTable DT_SaleSku { get; set; }
        public DataTable DT_Transaction { get; set; }
        public DataTable DTProduct { get; set; }
        public string InvoiceNo { get; set; }
        public DateTime InvoiceDate { get; set; }
        public string ContactNo { get; set; }
        public string Email { get; set; }
        public int ShiftId { get; set; }
        public int CustomerId { get; set; }
        public int CartItemId { get; set; }
        public string OrderNo { get; set; }
        public string GiftCardCode { get; set; }
        public int OrderId { get; set; }
        public decimal SKUAmt { get; set; }
        public string SKUName { get; set; }
        public string CustomerIdG { get; set; }
        public int InvoiceAutoId { get; set; }
        public int DraftAutoId { get; set; }
        public int UsedRoyaltyPoints { get; set; }
        public decimal Discount { get; set; }
        public string DraftName { get; set; }
        public string CustomerName { get; set; }
        public decimal CouponAmt { get; set; }
        public string DraftType { get; set; }
        public int CardType { get; set; }
        public string CardNo { get; set; }
        //public string SoldGiftCardList { get; set; }
        public DateTime DOB { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public DataTable TableValue { get; set; }

        public string GiftCardNo { get; set; }
        public decimal GiftCardAmt { get; set; }
        public decimal LeftAmt { get; set; }
        public decimal GiftCardLftAmt { get; set; }
        public decimal GiftCardUsedAmt { get; set; }
        public decimal RoyaltyAmount { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string MobileNo { get; set; }
        public string EmailId { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public int State { get; set; }
        public int Department { get; set; }
        public string ZipCode { get; set; }
        public string ProductName { get; set; }
        public string Remark { get; set; }
        public string DateTime { get; set; }

    }
    public class DL_orderMaster
    {
        public static void Returntable(PL_orderMaster pobj)
        {
            try
            {
                Config connect = new Config();
                SqlCommand sqlCmd = new SqlCommand("ProcOrderMaster", connect.con);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandTimeout = 10000;
                sqlCmd.Parameters.AddWithValue("@Opcode", pobj.Opcode);

                sqlCmd.Parameters.AddWithValue("@BrandAutoId", pobj.BrandAutoId);
                sqlCmd.Parameters.AddWithValue("@CouponCode", pobj.CouponCode);
                sqlCmd.Parameters.AddWithValue("@DateTime", pobj.DateTime);
                sqlCmd.Parameters.AddWithValue("@TotalAmt", pobj.TotalAmt);
                sqlCmd.Parameters.AddWithValue("@Remark", pobj.Remark);
                sqlCmd.Parameters.AddWithValue("@ScreenName", pobj.ScreenName);
                sqlCmd.Parameters.AddWithValue("@ScreenId", pobj.ScreenId);
                sqlCmd.Parameters.AddWithValue("@Status", pobj.Status);
                sqlCmd.Parameters.AddWithValue("@TrnsStatus", pobj.TrnsStatus);
                sqlCmd.Parameters.AddWithValue("@LeftAmt", pobj.LeftAmt);
                sqlCmd.Parameters.AddWithValue("@Department", pobj.Department);
                sqlCmd.Parameters.AddWithValue("@CustomerIdG", pobj.CustomerIdG);
                sqlCmd.Parameters.AddWithValue("@UserTypeId", pobj.UserTypeId);
                sqlCmd.Parameters.AddWithValue("@BalanceAutoId", pobj.BalanceAutoId);
                sqlCmd.Parameters.AddWithValue("@TerminalId", pobj.TerminalId);
                sqlCmd.Parameters.AddWithValue("@PaymentMethod", pobj.PaymentMethod);
                sqlCmd.Parameters.AddWithValue("@PaidAmount", pobj.PaidAmount);
                sqlCmd.Parameters.AddWithValue("@DraftAutoId", pobj.DraftAutoId);
                sqlCmd.Parameters.AddWithValue("@InvoiceNo", pobj.InvoiceNo);
                sqlCmd.Parameters.AddWithValue("@DraftName", pobj.DraftName);
                sqlCmd.Parameters.AddWithValue("@DraftType", pobj.DraftType);
                sqlCmd.Parameters.AddWithValue("@ContactNo", pobj.ContactNo);
                sqlCmd.Parameters.AddWithValue("@CustomerId", pobj.CustomerId);
                sqlCmd.Parameters.AddWithValue("@TempInvoiceNo", pobj.TempInvoiceNo);
                sqlCmd.Parameters.AddWithValue("@TransactionId", pobj.TransactionId);
                sqlCmd.Parameters.AddWithValue("@CreditCardLastFourDigits", pobj.CreditCardLastFourDigits);
                sqlCmd.Parameters.AddWithValue("@AuthCode", pobj.AuthCode);
                sqlCmd.Parameters.AddWithValue("@SKUAutoId", pobj.SKUAutoId);
                sqlCmd.Parameters.AddWithValue("@Product", pobj.Product);
                sqlCmd.Parameters.AddWithValue("@CouponAmt", pobj.CouponAmt);
                sqlCmd.Parameters.AddWithValue("@RoyaltyAmount", pobj.RoyaltyAmount);
                sqlCmd.Parameters.AddWithValue("@UsedRoyaltyPoints", pobj.UsedRoyaltyPoints);
                sqlCmd.Parameters.AddWithValue("@Type", pobj.Type);
                sqlCmd.Parameters.AddWithValue("@ShiftId", pobj.ShiftId);

                sqlCmd.Parameters.AddWithValue("@OrderId", pobj.OrderId);
                sqlCmd.Parameters.AddWithValue("@OrderNo", pobj.OrderNo);
                sqlCmd.Parameters.AddWithValue("@SKUNames", pobj.SKUName);
                sqlCmd.Parameters.AddWithValue("@GiftCardCode", pobj.GiftCardCode);
                sqlCmd.Parameters.AddWithValue("@SKUAmt", pobj.SKUAmt);

                sqlCmd.Parameters.AddWithValue("@ProductName", pobj.ProductName);
                sqlCmd.Parameters.AddWithValue("@CustomerName", pobj.CustomerName);
                sqlCmd.Parameters.AddWithValue("@SecuirtyCode", pobj.SecuirtyCode);
                sqlCmd.Parameters.AddWithValue("@OpeningBalance", pobj.OpeningBalance);
                sqlCmd.Parameters.AddWithValue("@ClosingBalance", pobj.ClosingBalance);
                sqlCmd.Parameters.AddWithValue("@CreatedFrom", pobj.CreatedFrom);
                sqlCmd.Parameters.AddWithValue("@CurrentBalStatus", pobj.CurrentBalStatus);
                sqlCmd.Parameters.AddWithValue("@CurrentBalance", pobj.CurrentBalance);

                sqlCmd.Parameters.AddWithValue("@ProductAutoId", pobj.ProductAutoId);
                sqlCmd.Parameters.AddWithValue("@PackingAutoId", pobj.PackingAutoId);
                sqlCmd.Parameters.AddWithValue("@CategoryId", pobj.CategoryId);
                sqlCmd.Parameters.AddWithValue("@Fav", pobj.Fav);
                if (pobj.DOB > DateTime.MinValue && pobj.DOB < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@DOB", pobj.DOB);
                }
                if (pobj.InvoiceDate > DateTime.MinValue && pobj.InvoiceDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@InvoiceDate", pobj.InvoiceDate);
                }
                if (pobj.FromDate > DateTime.MinValue && pobj.FromDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@FromDate", pobj.FromDate);
                }
                if (pobj.ToDate > DateTime.MinValue && pobj.ToDate < DateTime.MaxValue)
                {
                    sqlCmd.Parameters.AddWithValue("@ToDate", pobj.ToDate);
                }
                sqlCmd.Parameters.AddWithValue("@Quantity", pobj.Quantity);
                sqlCmd.Parameters.AddWithValue("@MinAge", pobj.MinAge);
                sqlCmd.Parameters.AddWithValue("@Discount", pobj.Discount);
                sqlCmd.Parameters.AddWithValue("@SchemeId", pobj.SchemeId);
                sqlCmd.Parameters.AddWithValue("@StoreId", pobj.StoreId);
                sqlCmd.Parameters.AddWithValue("@InvoiceAutoId", pobj.InvoiceAutoId);
                sqlCmd.Parameters.AddWithValue("@Barcode", pobj.Barcode);
                sqlCmd.Parameters.AddWithValue("@DT_SKUDraft", pobj.TableValue);
                sqlCmd.Parameters.AddWithValue("@CardNo", pobj.CardNo);
                sqlCmd.Parameters.AddWithValue("@FirstName", pobj.FirstName);
                sqlCmd.Parameters.AddWithValue("@LastName", pobj.LastName);
                sqlCmd.Parameters.AddWithValue("@MobileNo", pobj.MobileNo);
                sqlCmd.Parameters.AddWithValue("@EmailId", pobj.EmailId);
                sqlCmd.Parameters.AddWithValue("@Address", pobj.Address);
                sqlCmd.Parameters.AddWithValue("@City", pobj.City);
                sqlCmd.Parameters.AddWithValue("@State", pobj.State);
                sqlCmd.Parameters.AddWithValue("@ZipCode", pobj.ZipCode);
                sqlCmd.Parameters.AddWithValue("@CardType", pobj.CardType);
                sqlCmd.Parameters.AddWithValue("@GiftCardAmt", pobj.GiftCardAmt);
                sqlCmd.Parameters.AddWithValue("@GiftCardNo", pobj.GiftCardNo);
                sqlCmd.Parameters.AddWithValue("@GiftCardLftAmt", pobj.GiftCardLftAmt);
                sqlCmd.Parameters.AddWithValue("@GiftCardUsedAmt", pobj.GiftCardUsedAmt);
                sqlCmd.Parameters.AddWithValue("@CartItemId", pobj.CartItemId);
                //sqlCmd.Parameters.AddWithValue("@SoldGiftCardList", pobj.SoldGiftCardList);

                if (pobj.DT_SaleSku != null)
                {
                    if (pobj.DT_SaleSku.Rows.Count > 0)
                    {
                        sqlCmd.Parameters.AddWithValue("@DT_SaleSku", pobj.DT_SaleSku);
                    }
                }
                if (pobj.DTProduct != null)
                {
                    if (pobj.DTProduct.Rows.Count > 0)
                    {
                        sqlCmd.Parameters.AddWithValue("@DT_SaleInvoiceItem", pobj.DTProduct);
                    }
                }
                if (pobj.CurrencyTable != null)
                {
                    if (pobj.CurrencyTable.Rows.Count > 0)
                    {
                        sqlCmd.Parameters.AddWithValue("@CurrencyTable", pobj.CurrencyTable);
                    }
                }
                if (pobj.DT_Transaction != null)
                {
                    if (pobj.DT_Transaction.Rows.Count > 0)
                    {
                        sqlCmd.Parameters.AddWithValue("@DT_TransactionDetails", pobj.DT_Transaction);
                    }
                }
                sqlCmd.Parameters.AddWithValue("@PageIndex", pobj.PageIndex);
                sqlCmd.Parameters.AddWithValue("@PageSize", pobj.PageSize);
                sqlCmd.Parameters.AddWithValue("@RecordCount", pobj.RecordCount);
                sqlCmd.Parameters.AddWithValue("@Who", pobj.Who);
                //sqlCmd.Parameters.AddWithValue("@TerminalId", DllUtility.Globals.Terminal);
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
    public class BL_orderMaster
    {
        public static void InsertInvoice(PL_orderMaster pobj)
        {
            pobj.Opcode = 11;
            DL_orderMaster.Returntable(pobj);
        }
        public static void DraftOrder(PL_orderMaster pobj)
        {
            pobj.Opcode = 12;
            DL_orderMaster.Returntable(pobj);
        }
        public static void GetDraftDetail(PL_orderMaster pobj)
        {
            pobj.Opcode = 122;
            DL_orderMaster.Returntable(pobj);
        }
        public static void UpdateDraft(PL_orderMaster pobj)
        {
            pobj.Opcode = 46;
            DL_orderMaster.Returntable(pobj);
        }
        public static void OpeningBalance(PL_orderMaster pobj)
        {
            pobj.Opcode = 13;
            DL_orderMaster.Returntable(pobj);
        }
        public static void BreakLog(PL_orderMaster pobj)
        {
            pobj.Opcode = 55;
            DL_orderMaster.Returntable(pobj);
        }
        public static void ClosingBalance(PL_orderMaster pobj)
        {
            pobj.Opcode = 14;
            DL_orderMaster.Returntable(pobj);
        }
        public static void NoSale(PL_orderMaster pobj)
        {
            pobj.Opcode = 15;
            DL_orderMaster.Returntable(pobj);
        }
        public static void BindEmployeeList(PL_orderMaster pobj)
        {
            pobj.Opcode = 412;
            DL_orderMaster.Returntable(pobj);
        }
        public static void BindNoSaleReport(PL_orderMaster pobj)
        {
            pobj.Opcode = 411;
            DL_orderMaster.Returntable(pobj);
        }
        public static void BindCardType(PL_orderMaster pobj)
        {
            pobj.Opcode = 413;
            DL_orderMaster.Returntable(pobj);
        }
        public static void GetRoyaltyRedeemCriteria(PL_orderMaster pobj)
        {
            pobj.Opcode = 415;
            DL_orderMaster.Returntable(pobj);
        }
        //public static void NoSale(PL_orderMaster pobj)
        //{
        //    pobj.Opcode = 13;
        //    DL_orderMaster.Returntable(pobj);
        //}
        //public static void CancelInvoice(PL_orderMaster pobj)
        //{
        //    pobj.Opcode = 21;
        //    DL_orderMaster.Returntable(pobj);
        //}
        public static void AddToFavorite(PL_orderMaster pobj)
        {
            pobj.Opcode = 22;
            DL_orderMaster.Returntable(pobj);
        }

        //public static void BindCategory(PL_orderMaster pobj)
        //{
        //    pobj.Opcode = 41;
        //    DL_orderMaster.Returntable(pobj);
        //}
        //public static void BindProduct(PL_orderMaster pobj)
        //{
        //    pobj.Opcode = 42;
        //    DL_orderMaster.Returntable(pobj);
        //}
        //public static void BindPaymentType(PL_orderMaster pobj)
        //{
        //    pobj.Opcode = 43;
        //    DL_orderMaster.Returntable(pobj);
        //}
        //public static void BindSku(PL_orderMaster pobj)
        //{
        //    pobj.Opcode = 45;
        //    DL_orderMaster.Returntable(pobj);
        //}
        //public static void BindSkuDetail(PL_orderMaster pobj)
        //{
        //    pobj.Opcode = 46;
        //    DL_orderMaster.Returntable(pobj);
        //}
        //public static void BindSkuQuantityDetail(PL_orderMaster pobj)
        //{
        //    pobj.Opcode = 47;
        //    DL_orderMaster.Returntable(pobj);
        //}
        //public static void BindSKUProduct(PL_orderMaster pobj)
        //{
        //    pobj.Opcode = 48;
        //    DL_orderMaster.Returntable(pobj);
        //}
        //public static void BindSkuBySKU(PL_orderMaster pobj)
        //{
        //    pobj.Opcode = 49;
        //    DL_orderMaster.Returntable(pobj);
        //}
        public static void RedeemGiftCard(PL_orderMaster pobj)
        {
            pobj.Opcode = 414;
            DL_orderMaster.Returntable(pobj);
        }
        public static void BindByBarcode(PL_orderMaster pobj)
        {
            pobj.Opcode = 50;
            DL_orderMaster.Returntable(pobj);
        }
        public static void AddToCart(PL_orderMaster pobj)
        {
            pobj.Opcode = 511;
            DL_orderMaster.Returntable(pobj);
        }
        public static void DeleteProductFromCart(PL_orderMaster pobj)
        {
            pobj.Opcode = 521;
            DL_orderMaster.Returntable(pobj);
        }
        public static void GetCart(PL_orderMaster pobj)
        {
            pobj.Opcode = 531;
            DL_orderMaster.Returntable(pobj);
        }
        public static void AddDiscount(PL_orderMaster pobj)
        {
            pobj.Opcode = 541;
            DL_orderMaster.Returntable(pobj);
        }
        public static void Print_SafeCash(PL_orderMaster pobj)
        {
            pobj.Opcode = 54;
            DL_orderMaster.Returntable(pobj);
        }
        public static void RemoveDiscount(PL_orderMaster pobj)
        {
            pobj.Opcode = 551;
            DL_orderMaster.Returntable(pobj);
        }
        public static void DraftOrderLog(PL_orderMaster pobj)
        {
            pobj.Opcode = 56;
            DL_orderMaster.Returntable(pobj);
        }
        public static void BindDraftOrder(PL_orderMaster pobj)
        {
            pobj.Opcode = 57;
            DL_orderMaster.Returntable(pobj);
        }
        public static void Print_Invoice(PL_orderMaster pobj)
        {
            pobj.Opcode = 62;
            DL_orderMaster.Returntable(pobj);
        }
        public static void SaleInvoiceList(PL_orderMaster pobj)
        {
            pobj.Opcode = 63;
            DL_orderMaster.Returntable(pobj);
        }
        public static void SaleInvoiceItemList(PL_orderMaster pobj)
        {
            pobj.Opcode = 64;
            DL_orderMaster.Returntable(pobj);
        }
        public static void LoginAsAdmin(PL_orderMaster pobj)
        {
            pobj.Opcode = 65;
            DL_orderMaster.Returntable(pobj);
        }

        public static void deleteDraftItem(PL_orderMaster pobj)
        {
            pobj.Opcode = 30;
            DL_orderMaster.Returntable(pobj);
        }
        //public static void BindSKUDetailForFav(PL_orderMaster pobj)
        //{
        //    pobj.Opcode = 58;
        //    DL_orderMaster.Returntable(pobj);
        //}
        //public static void PrintLastInvoice(PL_orderMaster pobj)
        //{
        //    pobj.Opcode = 59;
        //    DL_orderMaster.Returntable(pobj);
        //}
        //public static void BindFavSKU(PL_orderMaster pobj)
        //{
        //    pobj.Opcode = 60;
        //    DL_orderMaster.Returntable(pobj);
        //}
        public static void ResetCart(PL_orderMaster pobj)
        {
            pobj.Opcode = 561;
            DL_orderMaster.Returntable(pobj);
        }
        public static void BindProductList(PL_orderMaster pobj)
        {
            pobj.Opcode = 100;
            DL_orderMaster.Returntable(pobj);
        }
        public static void BindAllDropDowns(PL_orderMaster pobj)
        {
            pobj.Opcode = 101;
            DL_orderMaster.Returntable(pobj);
        }
        public static void AddCustomer(PL_orderMaster pobj)
        {
            pobj.Opcode = 102;
            DL_orderMaster.Returntable(pobj);
        }
        public static void SearchCustomer(PL_orderMaster pobj)
        {
            pobj.Opcode = 103;
            DL_orderMaster.Returntable(pobj);
        }
        public static void BindSKUByProduct(PL_orderMaster pobj)
        {
            pobj.Opcode = 104;
            DL_orderMaster.Returntable(pobj);
        }
        public static void BindSKUByBarcode(PL_orderMaster pobj)
        {
            pobj.Opcode = 105;
            DL_orderMaster.Returntable(pobj);
        }
        public static void AddToHomeProduct(PL_orderMaster pobj)
        {
            pobj.Opcode = 108;
            DL_orderMaster.Returntable(pobj);
        }
        public static void CreateTransactionLog(PL_orderMaster pobj)
        {
            pobj.Opcode = 109;
            DL_orderMaster.Returntable(pobj);
        }
        public static void BindDepartment(PL_orderMaster pobj)
        {
            pobj.Opcode = 107;
            DL_orderMaster.Returntable(pobj);
        }
        public static void InsertScreen(PL_orderMaster pobj)
        {
            pobj.Opcode = 25;
            DL_orderMaster.Returntable(pobj);
        }
        public static void GetScreen(PL_orderMaster pobj)
        {
            pobj.Opcode = 26;
            DL_orderMaster.Returntable(pobj);
        }
        public static void DeleteScreen(PL_orderMaster pobj)
        {
            pobj.Opcode = 27;
            DL_orderMaster.Returntable(pobj);
        }
        public static void bindScreen(PL_orderMaster pobj)
        {
            pobj.Opcode = 28;
            DL_orderMaster.Returntable(pobj);
        }
        public static void AddToProductScreen(PL_orderMaster pobj)
        {
            pobj.Opcode = 29;
            DL_orderMaster.Returntable(pobj);
        }
        public static void BindScreenProduct(PL_orderMaster pobj)
        {
            pobj.Opcode = 31;
            DL_orderMaster.Returntable(pobj);
        }
        public static void bindPayoutType(PL_orderMaster pobj)
        {
            pobj.Opcode = 32;
            DL_orderMaster.Returntable(pobj);
        }
        public static void bindVendor(PL_orderMaster pobj)
        {
            pobj.Opcode = 33;
            DL_orderMaster.Returntable(pobj);
        }
        public static void bindExpenses(PL_orderMaster pobj)
        {
            pobj.Opcode = 34;
            DL_orderMaster.Returntable(pobj);
        }
        public static void editScreen(PL_orderMaster pobj)
        {
            pobj.Opcode = 35;
            DL_orderMaster.Returntable(pobj);
        }
        public static void UpdateScreen(PL_orderMaster pobj)
        {
            pobj.Opcode = 36;
            DL_orderMaster.Returntable(pobj);
        }
        public static void GiveDiscount(PL_orderMaster pobj)
        {
            pobj.Opcode = 37;
            DL_orderMaster.Returntable(pobj);
        }
        public static void BindCurrencyList(PL_orderMaster pobj)
        {
            pobj.Opcode = 38;
            DL_orderMaster.Returntable(pobj);
        }
        public static void BindCurrentCash(PL_orderMaster pobj)
        {
            pobj.Opcode = 58;
            DL_orderMaster.Returntable(pobj);
        }
        public static void BindClosCurrencyList(PL_orderMaster pobj)
        {
            pobj.Opcode = 47;
            DL_orderMaster.Returntable(pobj);
        }
        public static void ApplyCoupon(PL_orderMaster pobj)
        {
            pobj.Opcode = 39;
            DL_orderMaster.Returntable(pobj);
        }
        public static void ClockIn(PL_orderMaster pobj)
        {
            pobj.Opcode = 40;
            DL_orderMaster.Returntable(pobj);
        }
        public static void CheckClockInOut(PL_orderMaster pobj)
        {
            pobj.Opcode = 41;
            DL_orderMaster.Returntable(pobj);
        }
        public static void ClockOut(PL_orderMaster pobj)
        {
            pobj.Opcode = 42;
            DL_orderMaster.Returntable(pobj);
        }
        public static void SaveDeposit(PL_orderMaster pobj)
        {
            pobj.Opcode = 43;
            DL_orderMaster.Returntable(pobj);
        }
        public static void SaveWithdraw(PL_orderMaster pobj)
        {
            pobj.Opcode = 44;
            DL_orderMaster.Returntable(pobj);
        }
        public static void WithdrawSecurity(PL_orderMaster pobj)
        {
            pobj.Opcode = 45;
            DL_orderMaster.Returntable(pobj);
        }
        public static void AddGiftCard(PL_orderMaster pobj)
        {
            pobj.Opcode = 48;
            DL_orderMaster.Returntable(pobj);
        }
        public static void FillCustomerDetails(PL_orderMaster pobj)
        {
            pobj.Opcode = 49;
            DL_orderMaster.Returntable(pobj);
        }
        public static void CheckStore(PL_orderMaster pobj)
        {
            pobj.Opcode = 53;
            DL_orderMaster.Returntable(pobj);
        }
    }
}

