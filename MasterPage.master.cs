using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterPage : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                if (Session["EmpAutoId"] == null)
                {
                    Session.Abandon();
                    Response.Redirect("~/Default.aspx", false);
                }
                else if (Convert.ToInt32(Session["EmpTypeNo"]) == 4 && Session["CashierLogin"].ToString() != "YES")
                {
                    Session.Abandon();
                    Response.Redirect("~/Default.aspx?session=0", false);
                }
                else
                {
                    if (Convert.ToInt32(Session["EmpStoreCount"]) > 1)
                    {
                        lblChangeStore.Visible = true;
                    }
                    else
                    {
                        lblChangeStore.Visible = false;
                    }
                    lblUserName.InnerHtml = Session["EmpFirstName"].ToString();
                    lblCompanyName.InnerHtml = Session["CompanyName"].ToString();
                    lblUserType.InnerHtml = Session["EmpType"].ToString();
                    lblUserAutoId.Value = Session["EmpAutoId"].ToString();
                    if (Session["EmpType"].ToString() == "Admin")
                    {
                        liDashboard.Visible = true;
                        liCashier.Visible = false;
                        liSaleInvoiceList.Visible = true;
                        liPayoutMaster.Visible = true;
                        liDepartmentMaster.Visible = true;
                        liBrandMaster.Visible = true;
                        liCategoryMaster.Visible = true;
                        liProductMaster.Visible = true;
                        liSKUMaster.Visible = true;
                        liSchemeMaster.Visible = true;
                        liVendorMaster.Visible = true;
                        liPOList.Visible = true;
                        liPurchaseInvoiceList.Visible = true;
                        liStoreMaster.Visible = true;
                        liGiftCardMaster.Visible = true;
                        liCouponMaster.Visible = true;
                        liUserMaster.Visible = true;
                        liTaxMaster.Visible = true;
                        liAgeRestrictionMaster.Visible = true;
                        liTerminalMaster.Visible = true;
                        liModuleMaster.Visible = false;
                        liSubModuleMaster.Visible = false;
                        liComponentMaster.Visible = false;
                        liNoSaleReport.Visible = true;
                        liZReport.Visible = true;
                        liLoginReport.Visible = true;
                        liTerminalLoginReport.Visible = true;
                        liClockInOutReport.Visible=true;
                        liSafeCash.Visible=true;
                        liAppSetting.Visible=true;
                        liRoyaltyMaster.Visible=true;
                        liExpenseMaster.Visible=true;
                        liPurchaseHistory.Visible=false;
                        liExpenseReport.Visible=true;
                        liCategorySalesReport.Visible=true;
                        liLiveCart.Visible=true;
                        liInvoicePrintDetails.Visible=true;
                        liStoreLoginReport.Visible=true;
                        liHourlyRateReport.Visible = true;
                        liPrintBarcode.Visible = true;
                        liMixNMatchMaster.Visible = true;
                    }
                    else if (Session["EmpType"].ToString() == "Manager")
                    {
                        liDashboard.Visible = true;
                        liCashier.Visible = false;
                        liSaleInvoiceList.Visible = true;
                        liPayoutMaster.Visible = true;
                        liDepartmentMaster.Visible = true;
                        liBrandMaster.Visible = true;
                        liCategoryMaster.Visible = true;
                        liProductMaster.Visible = true;
                        liSKUMaster.Visible = true;
                        liSchemeMaster.Visible = true;
                        liVendorMaster.Visible = true;
                        liPOList.Visible = true;
                        liPurchaseInvoiceList.Visible = true;
                        liStoreMaster.Visible = false;
                        liGiftCardMaster.Visible = true;
                        liCouponMaster.Visible = true;
                        liUserMaster.Visible = false;
                        liTaxMaster.Visible = true;
                        liAgeRestrictionMaster.Visible = true;
                        liTerminalMaster.Visible = false;
                        liModuleMaster.Visible = false;
                        liSubModuleMaster.Visible = false;
                        liComponentMaster.Visible = false;
                        liNoSaleReport.Visible = true;
                        liZReport.Visible = true;
                        liLoginReport.Visible = false;
                        liTerminalLoginReport.Visible = true;
                        liClockInOutReport.Visible = true;
                        liSafeCash.Visible = true;
                        liAppSetting.Visible = false;
                        liRoyaltyMaster.Visible = true;
                        liExpenseMaster.Visible = true;
                        liPurchaseHistory.Visible = false;
                        liExpenseReport.Visible = true;
                        liCategorySalesReport.Visible = true;
                        liLiveCart.Visible = true;
                        liInvoicePrintDetails.Visible = true;
                        liStoreLoginReport.Visible = false;
                        liHourlyRateReport.Visible = true;
                        liPrintBarcode.Visible = true;
                        liMixNMatchMaster.Visible = true;

                    }
                    else if (Session["EmpType"].ToString() == "Cashier")
                    {
                        liDashboard.Visible = true;
                        liCashier.Visible = true;
                        liSaleInvoiceList.Visible = true;
                        liPayoutMaster.Visible = true;
                        liDepartmentMaster.Visible = true;
                        liBrandMaster.Visible = true;
                        liCategoryMaster.Visible = true;
                        liProductMaster.Visible = true;
                        liSKUMaster.Visible = true;
                        liPurchaseMaster.Visible = false;
                        liSettingMaster.Visible = false;
                        liReportManagement.Visible = false;
                        liSchemeMaster.Visible = true;
                        liVendorMaster.Visible = false;
                        liPOList.Visible = false;
                        liPurchaseInvoiceList.Visible = false;
                        liStoreMaster.Visible = false;
                        liGiftCardMaster.Visible = false;
                        liCouponMaster.Visible = false;
                        liUserMaster.Visible = false;
                        liTaxMaster.Visible = false;
                        liAgeRestrictionMaster.Visible = false;
                        liTerminalMaster.Visible = false;
                        liModuleMaster.Visible = false;
                        liSubModuleMaster.Visible = false;
                        liComponentMaster.Visible = false;
                        liNoSaleReport.Visible = false;
                        liZReport.Visible = false;
                        liLoginReport.Visible = false;
                        liTerminalLoginReport.Visible = false;
                        liClockInOutReport.Visible = false;
                        liSafeCash.Visible = false;
                        liAppSetting.Visible = false;
                        liRoyaltyMaster.Visible = false;
                        liExpenseMaster.Visible = false;
                        liPurchaseHistory.Visible = false;
                        liExpenseReport.Visible = false;
                        liCategorySalesReport.Visible = false;
                        liLiveCart.Visible = false;
                        liInvoicePrintDetails.Visible = false;
                        liStoreLoginReport.Visible = false;
                        liPrintBarcode.Visible = false;
                        liMixNMatchMaster.Visible = false;
                    }
                    else if (Session["EmpType"].ToString() == "HR")
                    {
                        liDashboard.Visible = true;
                        liCashier.Visible = false;
                        liSaleInvoiceList.Visible = false;
                        liPayoutMaster.Visible = false;
                        liDepartmentMaster.Visible = false;
                        liBrandMaster.Visible = false;
                        liCategoryMaster.Visible = false;
                        liProductMaster.Visible = false;
                        liSKUMaster.Visible = false;
                        liSchemeMaster.Visible = false;
                        liVendorMaster.Visible = false;
                        liPOList.Visible = false;
                        liPurchaseInvoiceList.Visible = false;
                        liStoreMaster.Visible = false;
                        liGiftCardMaster.Visible = false;
                        liCouponMaster.Visible = false;
                        liUserMaster.Visible = false;
                        liTaxMaster.Visible = false;
                        liAgeRestrictionMaster.Visible = false;
                        liTerminalMaster.Visible = false;
                        liModuleMaster.Visible = false;
                        liSubModuleMaster.Visible = false;
                        liComponentMaster.Visible = false;
                        liNoSaleReport.Visible = false;
                        liZReport.Visible = false;
                        liLoginReport.Visible = false;
                        liTerminalLoginReport.Visible = false;
                        liSafeCash.Visible = false;
                        liAppSetting.Visible = false;
                        liRoyaltyMaster.Visible = false;
                        liExpenseMaster.Visible = false;
                        liPurchaseHistory.Visible = false;
                        liExpenseReport.Visible = false;
                        liCategorySalesReport.Visible = false;
                        liLiveCart.Visible = false;
                        liInvoicePrintDetails.Visible = false;
                        liStoreLoginReport.Visible = false;
                        liHourlyRateReport.Visible = false;
                        liPrintBarcode.Visible = false;
                        liMixNMatchMaster.Visible = false;
                    }
                    else
                    {
                        liDashboard.Visible = true;
                        liCashier.Visible = false;
                        liSaleInvoiceList.Visible = false;
                        liPayoutMaster.Visible = false;
                        liDepartmentMaster.Visible = false;
                        liBrandMaster.Visible = false;
                        liCategoryMaster.Visible = false;
                        liProductMaster.Visible = false;
                        liSKUMaster.Visible = false;
                        liSchemeMaster.Visible = false;
                        liVendorMaster.Visible = false;
                        liPOList.Visible = false;
                        liPurchaseInvoiceList.Visible = false;
                        liStoreMaster.Visible = false;
                        liGiftCardMaster.Visible = false;
                        liCouponMaster.Visible = false;
                        liUserMaster.Visible = false;
                        liTaxMaster.Visible = false;
                        liAgeRestrictionMaster.Visible = false;
                        liTerminalMaster.Visible = false;
                        liModuleMaster.Visible = false;
                        liSubModuleMaster.Visible = false;
                        liComponentMaster.Visible = false;
                        liNoSaleReport.Visible = false;
                        liZReport.Visible = false;
                        liLoginReport.Visible = false;
                        liTerminalLoginReport.Visible = false;
                        liClockInOutReport.Visible = false;
                        liSafeCash.Visible = false;
                        liAppSetting.Visible = false;
                        liRoyaltyMaster.Visible = false;
                        liExpenseMaster.Visible = false;
                        liPurchaseHistory.Visible = false;
                        liExpenseReport.Visible = false;
                        liCategorySalesReport.Visible = false;
                        liLiveCart.Visible = false;
                        liInvoicePrintDetails.Visible = false;
                        liStoreLoginReport.Visible = false;
                        liHourlyRateReport.Visible = false;
                        liPrintBarcode.Visible = false;
                        liMixNMatchMaster.Visible = false;
                    }
                }
                //if (Session["EmpAutoId"] == null)
                //{
                //    Session.Abandon();
                //    Response.Redirect("~/Default.aspx", false);
                //}
                //else
                //{
                    
                //}
            }
            catch (Exception ex)
            {
                Session.Abandon();
                Response.Redirect("~/Default.aspx", false);
            }
        }
    }
}
