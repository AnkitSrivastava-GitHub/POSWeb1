using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_POSScreen : System.Web.UI.Page 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Session["EmpAutoId"] == null)
            {
                Session.Abandon();
                Response.Redirect("~/Default.aspx", false);
            }
            else if (HttpContext.Current.Session["empTypeno"].ToString() == "4")
            {
                hdnEmpId.Value = HttpContext.Current.Session["empTypeno"].ToString();
                hdnEmpAutoId.Value = HttpContext.Current.Session["EmpAutoId"].ToString();
                btnClosePOS.Visible = false;
                btnAdminPOS.Visible = true;
                btnLogout.Visible = true;
            }
            else
            {
                Session.Abandon();
                Response.Redirect("~/Default.aspx", false);
                //btnClosePOS.Visible = true;
                //btnAdminPOS.Visible = false;
                //btnLogout.Visible = false;
            }
        }
        catch (Exception ex)
        {
            Session.Abandon();
            Response.Redirect("~/Default.aspx", false);
        }
    }
}