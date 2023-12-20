using ODP_NET_Theatre.DAO;
using ODP_NET_Theatre.DAO.Impl;
using ODP_NET_Theatre.DTO.ComplexQuery1;
using ODP_NET_Theatre.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ODP_NET_Theatre.Service
{
    public class ComplexFuncionalityService
    {
        private static readonly ITheatreDAO theatreDAO = new TheatreDAOImpl();
        private static readonly ISceneDAO sceneDAO = new SceneDAOImpl();

        //complex query 1
        public List<ScenesForTheatreDTO> GetScenesForTheatres()
        {
             List<ScenesForTheatreDTO> ret = new List<ScenesForTheatreDTO>();
            foreach(Theatre t in theatreDAO.FindAll())
            {
                ScenesForTheatreDTO dto = new ScenesForTheatreDTO();
                dto.Theatre = t;
                dto.Scenes = sceneDAO.FindSceneByTheatre(t.IdTh);
                ret.Add(dto);
            }
            return ret;
        }

    }
}
