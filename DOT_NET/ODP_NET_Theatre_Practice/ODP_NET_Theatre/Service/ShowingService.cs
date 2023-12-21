using ODP_NET_Theatre.DAO;
using ODP_NET_Theatre.DAO.Impl;
using ODP_NET_Theatre.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ODP_NET_Theatre.Service
{
    public class ShowingService
    {
        private static readonly IShowingDAO showingDAO = new ShowingDAOImpl();

        public List<Showing>GetByPlayId(int id)
        {
            return showingDAO.FindShowingByPlayId(id);
        }

         
	}
}
