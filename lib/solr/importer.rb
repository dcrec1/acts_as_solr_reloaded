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

module Solr; module Importer; end; end
require File.expand_path("#{File.dirname(__FILE__)}/importer/mapper")
require File.expand_path("#{File.dirname(__FILE__)}/importer/array_mapper")
require File.expand_path("#{File.dirname(__FILE__)}/importer/delimited_file_source")
require File.expand_path("#{File.dirname(__FILE__)}/importer/hpricot_mapper")
require File.expand_path("#{File.dirname(__FILE__)}/importer/xpath_mapper")
require File.expand_path("#{File.dirname(__FILE__)}/importer/solr_source")