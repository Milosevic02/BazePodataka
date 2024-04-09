using ODP_NET_Theatre.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ODP_NET_Theatre.DTO.ComplexQuery2
{
    public class ShowingsForPlayDTO
    {
        public Play Play { get; set; }

        public PlayShowingsStatsDTO Stats { get; set; }

        public List<Showing>Showings { get; set; }

    }
}
