using DLLOrderMaster;
using DLLSchemeMaster;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_LiveCart : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["EmpAutoId"] == null)
        {
            Session.Abandon();
            Response.Redirect("~/Default.aspx", false);
        }
        else
        {
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/LiveCart.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
    }

    [WebMethod]
    public static string CurrencySymbol()
    {
        string CurrencySymbol = "";
        if (System.Web.HttpContext.Current.Session["CurrencySymbol"] != null)
        {

            CurrencySymbol = Convert.ToString(HttpContext.Current.Session["CurrencySymbol"]);

            return CurrencySymbol;
        }
        else
        {
            return "Session";
        }
    }

    [WebMethod]
    public static string BindStore()
    {
        global::DLLLiveCart.PL_LiveCart pobj = new global::DLLLiveCart.PL_LiveCart();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                global::DLLLiveCart.BL_LiveCart.BindStore(pobj);
                if (pobj.isException != true)
                {
                    return pobj.Ds.GetXml();
                }
                else
                {
                    return "false";
                }
            }
            else
            {
                return "Session";
            }
        }
        catch (Exception ex)
        {
            pobj.isException = true;
            pobj.exceptionMessage = ex.Message;
            return "false";
        }
    }

    [WebMethod]
    public static string BindTerminal(string StoreId)
    {
        global::DLLLiveCart.PL_LiveCart pobj = new global::DLLLiveCart.PL_LiveCart();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                if (StoreId == "0")
                {
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                }
                else
                {
                    pobj.StoreId = Convert.ToInt32(StoreId);
                }               
                
                global::DLLLiveCart.BL_LiveCart.BindTerminal(pobj);
                if (pobj.isException != true)
                {
                    return pobj.Ds.GetXml();
                }
                else
                {
                    return "false";
                }
            }
            else
            {
                return "Session";
            }
        }
        catch (Exception ex)
        {
            pobj.isException = true;
            pobj.exceptionMessage = ex.Message;
            return "false";
        }
    }

    [WebMethod]
    public static string BindLiveCart(string dataValues)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValues);
        global::DLLLiveCart.PL_LiveCart pobj = new global::DLLLiveCart.PL_LiveCart();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                if (jdv["StoreId"] == "0")
                {
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                }
                else
                {
                    pobj.StoreId = Convert.ToInt32(jdv["StoreId"]);
                }
                pobj.TerminalId = Convert.ToInt32(jdv["TerminalId"]);

                global::DLLLiveCart.BL_LiveCart.BindLiveCart(pobj);
                if (pobj.isException != true)
                {
                    string res = "";
                    if (pobj.Ds.Tables.Count > 0)
                    {
                        if (pobj.Ds.Tables[0].Rows.Count > 0)
                        {
                            foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                            {
                                res += row[0].ToString();
                            }
                        }
                    }
                    return res;
                }
                else
                {
                    return "false";
                }
            }
            else
            {
                return "Session";
            }
        }
        catch (Exception ex)
        {
            pobj.isException = true;
            pobj.exceptionMessage = ex.Message;
            return "false";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindSaleInvoiceList(string dataValues)
    {
        global::DLLLiveCart.PL_LiveCart pobj = new global::DLLLiveCart.PL_LiveCart();
        try
        {
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValues);
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                if (jdv["StoreId"] == "0")
                {
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                }
                else
                {
                    pobj.StoreId = Convert.ToInt32(jdv["StoreId"]);
                }
                pobj.TerminalId = Convert.ToInt32(jdv["TerminalId"]);
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                global::DLLLiveCart.BL_LiveCart.SaleInvoiceList(pobj);
                if (pobj.isException != true)
                {
                    return pobj.Ds.GetXml();
                }
                else
                {
                    return "false";
                }
            }
            else
            {
                return "Session";
            }
        }
        catch (Exception ex)
        {
            pobj.isException = true;
            pobj.exceptionMessage = ex.Message;
            return "false";
        }
    }
}