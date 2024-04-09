using ODP_NET_Theatre.DTO.ComplexQuery2;
using ODP_NET_Theatre.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ODP_NET_Theatre.DAO
{
    public interface IShowingDAO:ICRUDDao<Showing,int>
    {
        List<Showing>FindShowingByPlayId(int playId);

        List<PlayShowingsStatsDTO> FindSumAvgCountForShowingPlay();



    }
}
