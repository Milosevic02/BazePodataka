using ODP_NET_Theatre.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ODP_NET_Theatre.DAO
{
    public interface IRoleDAO
    {
        List<Role> FindRoleByPlayID(int plId);

        int FindCountForRoleGender(int plId, string gender);
    }
}
