/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "items/cylinder.hpp"
#include "declarations.hpp"
#include "items/item.hpp"
#include "utils/tools.hpp"

class Creature;
class Teleport;
class TrashHolder;
class Mailbox;
class MagicField;
class BedItem;
class House;
class Zone;

using CreatureVector = std::vector<std::shared_ptr<Creature>>;
using ItemVector = std::vector<std::shared_ptr<Item>>;
using SpectatorHashSet = phmap::flat_hash_set<std::shared_ptr<Creature>>;

class TileItemVector : private ItemVector {
public:
	using ItemVector::at;
	using ItemVector::begin;
	using ItemVector::clear;
	using ItemVector::const_iterator;
	using ItemVector::const_reverse_iterator;
	using ItemVector::empty;
	using ItemVector::end;
	using ItemVector::erase;
	using ItemVector::insert;
	using ItemVector::iterator;
	using ItemVector::push_back;
	using ItemVector::rbegin;
	using ItemVector::rend;
	using ItemVector::reverse_iterator;
	using ItemVector::size;
	using ItemVector::value_type;

	iterator getBeginDownItem() {
		return begin();
	}
	const_iterator getBeginDownItem() const {
		return begin();
	}
	iterator getEndDownItem() {
		return begin() + downItemCount;
	}
	const_iterator getEndDownItem() const {
		return begin() + downItemCount;
	}
	iterator getBeginTopItem() {
		return getEndDownItem();
	}
	const_iterator getBeginTopItem() const {
		return getEndDownItem();
	}
	iterator getEndTopItem() {
		return end();
	}
	const_iterator getEndTopItem() const {
		return end();
	}

	uint32_t getTopItemCount() const {
		return size() - downItemCount;
	}
	uint32_t getDownItemCount() const {
		return downItemCount;
	}
	inline std::shared_ptr<Item> getTopTopItem() const {
		if (getTopItemCount() == 0) {
			return nullptr;
		}
		return *(getEndTopItem() - 1);
	}
	inline std::shared_ptr<Item> getTopDownItem() const {
		if (downItemCount == 0) {
			return nullptr;
		}
		return *getBeginDownItem();
	}
	void increaseDownItemCount() {
		downItemCount += 1;
	}
	void decreaseDownItemCount() {
		downItemCount -= 1;
	}

private:
	uint32_t downItemCount = 0;
};

class Tile : public Cylinder, public SharedObject {
public:
	static const std::shared_ptr<Tile> &nullptr_tile;
	Tile(uint16_t x, uint16_t y, uint8_t z) :
		tilePos(x, y, z) { }
	virtual ~Tile() {};

	// non-copyable
	Tile(const Tile &) = delete;
	Tile &operator=(const Tile &) = delete;

	virtual TileItemVector* getItemList() = 0;
	virtual const TileItemVector* getItemList() const = 0;
	virtual TileItemVector* makeItemList() = 0;

	virtual CreatureVector* getCreatures() = 0;
	virtual const CreatureVector* getCreatures() const = 0;
	virtual CreatureVector* makeCreatures() = 0;
	virtual std::shared_ptr<House> getHouse() {
		return nullptr;
	}

	int32_t getThrowRange() const override final {
		return 0;
	}
	bool isPushable() override final {
		return false;
	}

	std::shared_ptr<Tile> getTile() override final {
		return static_self_cast<Tile>();
	}
	std::shared_ptr<MagicField> getFieldItem() const;
	std::shared_ptr<Teleport> getTeleportItem() const;
	std::shared_ptr<TrashHolder> getTrashHolder() const;
	std::shared_ptr<Mailbox> getMailbox() const;
	std::shared_ptr<BedItem> getBedItem() const;

	std::shared_ptr<Creature> getTopCreature() const;
	std::shared_ptr<Creature> getBottomCreature() const;
	std::shared_ptr<Creature> getTopVisibleCreature(std::shared_ptr<Creature> creature) const;
	std::shared_ptr<Creature> getBottomVisibleCreature(std::shared_ptr<Creature> creature) const;
	std::shared_ptr<Item> getTopTopItem() const;
	std::shared_ptr<Item> getTopDownItem() const;
	bool isMoveableBlocking() const;
	std::shared_ptr<Thing> getTopVisibleThing(std::shared_ptr<Creature> creature);
	std::shared_ptr<Item> getItemByTopOrder(int32_t topOrder);

	size_t getThingCount() const {
		size_t thingCount = getCreatureCount() + getItemCount();
		if (ground) {
			thingCount++;
		}
		return thingCount;
	}
	// If these return != 0 the associated vectors are guaranteed to exists
	size_t getCreatureCount() const;
	size_t getItemCount() const;
	uint32_t getTopItemCount() const;
	uint32_t getDownItemCount() const;

	bool hasProperty(ItemProperty prop) const;
	bool hasProperty(std::shared_ptr<Item> exclude, ItemProperty prop) const;

	bool hasFlag(uint32_t flag) const {
		return hasBitSet(flag, this->flags);
	}
	void setFlag(uint32_t flag) {
		this->flags |= flag;
	}
	void resetFlag(uint32_t flag) {
		this->flags &= ~flag;
	}

	const phmap::parallel_flat_hash_set<std::shared_ptr<Zone>> getZones();

	ZoneType_t getZoneType() const {
		if (hasFlag(TILESTATE_PROTECTIONZONE)) {
			return ZONE_PROTECTION;
		} else if (hasFlag(TILESTATE_NOPVPZONE)) {
			return ZONE_NOPVP;
		} else if (hasFlag(TILESTATE_NOLOGOUT)) {
			return ZONE_NOLOGOUT;
		} else if (hasFlag(TILESTATE_PVPZONE)) {
			return ZONE_PVP;
		} else {
			return ZONE_NORMAL;
		}
	}

	bool hasHeight(uint32_t n) const;

	std::string getDescription(int32_t lookDistance) override final;

	int32_t getClientIndexOfCreature(std::shared_ptr<Player> player, std::shared_ptr<Creature> creature) const;
	int32_t getStackposOfCreature(std::shared_ptr<Player> player, std::shared_ptr<Creature> creature) const;
	int32_t getStackposOfItem(std::shared_ptr<Player> player, std::shared_ptr<Item> item) const;

	// cylinder implementations
	ReturnValue queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, std::shared_ptr<Creature> actor = nullptr) override;
	ReturnValue queryMaxCount(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t &maxQueryCount, uint32_t flags) override final;
	ReturnValue queryRemove(const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t tileFlags, std::shared_ptr<Creature> actor = nullptr) override;
	std::shared_ptr<Cylinder> queryDestination(int32_t &index, const std::shared_ptr<Thing> &thing, std::shared_ptr<Item>* destItem, uint32_t &flags) override;

	std::vector<std::shared_ptr<Tile>> getSurroundingTiles();

	void addThing(std::shared_ptr<Thing> thing) override final;
	void addThing(int32_t index, std::shared_ptr<Thing> thing) override;

	void updateTileFlags(std::shared_ptr<Item> item);
	void updateThing(std::shared_ptr<Thing> thing, uint16_t itemId, uint32_t count) override final;
	void replaceThing(uint32_t index, std::shared_ptr<Thing> thing) override final;

	void removeThing(std::shared_ptr<Thing> thing, uint32_t count) override final;

	void removeCreature(std::shared_ptr<Creature> creature);

	int32_t getThingIndex(std::shared_ptr<Thing> thing) const override final;
	size_t getFirstIndex() const override final;
	size_t getLastIndex() const override final;
	uint32_t getItemTypeCount(uint16_t itemId, int32_t subType = -1) const override final;
	std::shared_ptr<Thing> getThing(size_t index) const override final;

	void postAddNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> oldParent, int32_t index, CylinderLink_t link = LINK_OWNER) override final;
	void postRemoveNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> newParent, int32_t index, CylinderLink_t link = LINK_OWNER) override final;

	void internalAddThing(std::shared_ptr<Thing> thing) override;
	void virtual internalAddThing(uint32_t index, std::shared_ptr<Thing> thing) override;

	const Position &getPosition() override final {
		return tilePos;
	}

	bool isRemoved() override final {
		return false;
	}

	std::shared_ptr<Item> getUseItem(int32_t index) const;
	std::shared_ptr<Item> getDoorItem() const;

	std::shared_ptr<Item> getGround() const {
		return ground;
	}
	void setGround(std::shared_ptr<Item> item) {
		ground = item;
	}

private:
	void onAddTileItem(std::shared_ptr<Item> item);
	void onUpdateTileItem(std::shared_ptr<Item> oldItem, const ItemType &oldType, std::shared_ptr<Item> newItem, const ItemType &newType);
	void onRemoveTileItem(const SpectatorHashSet &spectators, const std::vector<int32_t> &oldStackPosVector, std::shared_ptr<Item> item);
	void onUpdateTile(const SpectatorHashSet &spectators);

	void setTileFlags(std::shared_ptr<Item> item);
	void resetTileFlags(std::shared_ptr<Item> item);
	bool hasHarmfulField() const;
	ReturnValue checkNpcCanWalkIntoTile() const;

protected:
	std::shared_ptr<Item> ground = nullptr;
	Position tilePos;
	uint32_t flags = 0;
	std::shared_ptr<Zone> zone;
};

// Used for walkable tiles, where there is high likeliness of
// items being added/removed
class DynamicTile : public Tile {
	// By allocating the vectors in-house, we avoid some memory fragmentation
	TileItemVector items;
	CreatureVector creatures;

public:
	DynamicTile(uint16_t x, uint16_t y, uint8_t z) :
		Tile(x, y, z) { }

	// non-copyable
	DynamicTile(const DynamicTile &) = delete;
	DynamicTile &operator=(const DynamicTile &) = delete;

	TileItemVector* getItemList() override {
		return &items;
	}
	const TileItemVector* getItemList() const override {
		return &items;
	}
	TileItemVector* makeItemList() override {
		return &items;
	}

	CreatureVector* getCreatures() override {
		return &creatures;
	}
	const CreatureVector* getCreatures() const override {
		return &creatures;
	}
	CreatureVector* makeCreatures() override {
		return &creatures;
	}
};

// For blocking tiles, where we very rarely actually have items
class StaticTile final : public Tile {
	// We very rarely even need the vectors, so don't keep them in memory
	std::unique_ptr<TileItemVector> items;
	std::unique_ptr<CreatureVector> creatures;

public:
	StaticTile(uint16_t x, uint16_t y, uint8_t z) :
		Tile(x, y, z) { }

	// non-copyable
	StaticTile(const StaticTile &) = delete;
	StaticTile &operator=(const StaticTile &) = delete;

	TileItemVector* getItemList() override {
		return items.get();
	}
	const TileItemVector* getItemList() const override {
		return items.get();
	}
	TileItemVector* makeItemList() override {
		if (!items) {
			items = std::make_unique<TileItemVector>();
		}
		return items.get();
	}

	CreatureVector* getCreatures() override {
		return creatures.get();
	}
	const CreatureVector* getCreatures() const override {
		return creatures.get();
	}
	CreatureVector* makeCreatures() override {
		if (!creatures) {
			creatures = std::make_unique<CreatureVector>();
		}
		return creatures.get();
	}
};
