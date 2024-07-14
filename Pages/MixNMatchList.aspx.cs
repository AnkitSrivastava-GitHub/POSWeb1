using DLLProductGroup;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_MixNMatchList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/MixNMatchList.js"));
        Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
    }
    [WebMethod(EnableSession =true)]
    public static string MixNMatchList(string dataValue)
    {
        if (HttpContext.Current.Session["EmpAutoId"] !=null)
        {
            var jss=new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValue);
            PL_ProductGroup pobj=new PL_ProductGroup();
            try
            {
                pobj.GroupName= jdv["GroupName"];
                pobj.Status= Convert.ToInt32(jdv["GroupStatus"]);
                pobj.PageIndex= Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize= Convert.ToInt32(jdv["PageSize"]);
                pobj.StoreId= Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who= Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_ProductGroup.BindMixNMatchList(pobj);
                if (pobj.isException!=true)
                {
                    return pobj.Ds.GetXml();
                }
                else
                {
                    return "false";
                }
            }
            catch(Exception ex)
            {
                pobj.isException=true;
                pobj.exceptionMessage=ex.Message;
                return pobj.exceptionMessage;
            }
        }
        else
        {
            return "Session";
        }
    }
    [WebMethod(EnableSession =true)]
    public static string GroupItemList(string dataValue)
    {
        if (HttpContext.Current.Session["EmpAutoId"] !=null)
        {
            var jss=new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValue);
            PL_ProductGroup pobj=new PL_ProductGroup();
            try
            {
                pobj.GroupId = Convert.ToInt32(jdv["GroupId"]);
                pobj.PageIndex= Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize= Convert.ToInt32(jdv["PageSize"]);
                pobj.StoreId= Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who= Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_ProductGroup.BindMixNMatchItemList(pobj);
                if (pobj.isException!=true)
                {
                    return pobj.Ds.GetXml();
                }
                else
                {
                    return "false";
                }
            }
            catch(Exception ex)
            {
                pobj.isException=true;
                pobj.exceptionMessage=ex.Message;
                return pobj.exceptionMessage;
            }
        }
        else
        {
            return "Session";
        }
    }
    [WebMethod(EnableSession =true)]
    public static string DeleteGroup(int GroupId)
    {
        if (HttpContext.Current.Session["EmpAutoId"] !=null)
        {
            var jss=new JavaScriptSerializer();
            PL_ProductGroup pobj=new PL_ProductGroup();
            try
            {
                pobj.GroupId = Convert.ToInt32(GroupId);
                pobj.StoreId= Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who= Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_ProductGroup.DeleteGroup(pobj);
                if (pobj.isException!=true)
                {
                    return "true";
                }
                else
                {
                    return "false";
                }
            }
            catch(Exception ex)
            {
                pobj.isException=true;
                pobj.exceptionMessage=ex.Message;
                return pobj.exceptionMessage;
            }
        }
        else
        {
            return "Session";
        }
    }
}