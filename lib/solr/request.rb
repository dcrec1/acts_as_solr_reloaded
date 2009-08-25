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

module Solr; module Request; end; end
require File.expand_path("#{File.dirname(__FILE__)}/request/base")
require File.expand_path("#{File.dirname(__FILE__)}/request/update")
require File.expand_path("#{File.dirname(__FILE__)}/request/add_document")
require File.expand_path("#{File.dirname(__FILE__)}/request/modify_document")
require File.expand_path("#{File.dirname(__FILE__)}/request/commit")
require File.expand_path("#{File.dirname(__FILE__)}/request/delete")
require File.expand_path("#{File.dirname(__FILE__)}/request/ping")
require File.expand_path("#{File.dirname(__FILE__)}/request/select")
require File.expand_path("#{File.dirname(__FILE__)}/request/standard")
require File.expand_path("#{File.dirname(__FILE__)}/request/spellcheck")
require File.expand_path("#{File.dirname(__FILE__)}/request/dismax")
require File.expand_path("#{File.dirname(__FILE__)}/request/index_info")
require File.expand_path("#{File.dirname(__FILE__)}/request/optimize")
