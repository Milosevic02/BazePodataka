using ODP_NET_Theatre.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ODP_NET_Theatre.DTO.ComplexQuery1
{
    public class ScenesForTheatreDTO
    {
        public Theatre Theatre { get; set; }
        public List<Scene> Scenes { get; set; }
    }
}
