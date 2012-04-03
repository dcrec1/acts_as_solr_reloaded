# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class Solr::Request::Dismax < Solr::Request::Standard

  VALID_PARAMS.replace(VALID_PARAMS + [:tie_breaker, :query_fields, :minimum_match, :phrase_fields, :phrase_slop,
                                       :alternate_query, :boost_query, :boost_functions])

  def initialize(params)
    super("search")
  end
  
  def to_hash
    hash = super
    hash[:defType] = 'edismax'
    hash[:tie] = @params[:tie_breaker]
    hash[:mm]  = @params[:minimum_match]
    hash[:qf]  = @params[:query_fields]
    hash[:pf]  = @params[:phrase_fields]
    hash[:ps]  = @params[:phrase_slop]
    hash[:bq]  = @params[:boost_query]
    hash[:boost]  = @params[:boost_functions]
    hash["q.alt"] = @params[:alternate_query]

    return hash
  end

end
