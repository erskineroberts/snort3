//--------------------------------------------------------------------------
// Copyright (C) 2015-2015 Cisco and/or its affiliates. All rights reserved.
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License Version 2 as published
// by the Free Software Foundation.  You may not use, modify or distribute
// this program under any other version of the GNU General Public License.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program; if not, write to the Free Software Foundation, Inc.,
// 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
//--------------------------------------------------------------------------
// pp_inspector.cc author Joel Cornett <jocornet@cisco.com>

#include "piglet_plugins.h"

#include <string>
#include <assert.h>

#include "lua/lua_iface.h"
#include "managers/inspector_manager.h"
#include "piglet/piglet_api.h"
#include "stream/flush_bucket.h"

#include "pp_decode_data_iface.h"
#include "pp_flow_iface.h"
#include "pp_packet_iface.h"
#include "pp_raw_buffer_iface.h"
#include "pp_stream_splitter_iface.h"

#include "pp_inspector_iface.h"

class InspectorPiglet : public Piglet::BasePlugin
{
public:
    InspectorPiglet(Lua::State&, std::string, Module*);
    virtual ~InspectorPiglet() override;
    virtual bool setup() override;

private:
    InspectorWrapper* wrapper;
};

InspectorPiglet::InspectorPiglet(
    Lua::State& state, std::string target, Module* m) :
    BasePlugin(state, target, m)
{
    FlushBucket::set(0);

    assert(module);
    wrapper = InspectorManager::instantiate(target.c_str(), module);
}

InspectorPiglet::~InspectorPiglet()
{
    if ( wrapper )
        delete wrapper;
}

bool InspectorPiglet::setup()
{
    if ( !wrapper )
        return true;

    install(L, DecodeDataIface);
    install(L, RawBufferIface);
    install(L, FlowIface);
    install(L, PacketIface);
    install(L, StreamSplitterIface);

    install(L, InspectorIface, wrapper->instance);

    return false;
}

// -----------------------------------------------------------------------------
// API foo
// -----------------------------------------------------------------------------
static Piglet::BasePlugin* ctor(
    Lua::State& state, std::string target, Module* m, SnortConfig*)
{ return new InspectorPiglet(state, target, m); }

static void dtor(Piglet::BasePlugin* p)
{ delete p; }

static const struct Piglet::Api piglet_api =
{
    {
        PT_PIGLET,
        sizeof(Piglet::Api),
        PIGLET_API_VERSION,
        0,
        API_RESERVED,
        API_OPTIONS,
        "pp_inspector",
        "Inspector piglet",
        nullptr,
        nullptr
    },
    ctor,
    dtor,
    PT_INSPECTOR
};

const BaseApi* pp_inspector = &piglet_api.base;
