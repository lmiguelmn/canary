/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "items/cylinder.hpp"
#include "items/item.hpp"
#include "items/tile.hpp"

class Container;
class DepotChest;
class DepotLocker;
class RewardChest;
class Reward;

class ContainerIterator {
public:
	bool hasNext() const {
		return !over.empty();
	}

	void advance();
	std::shared_ptr<Item> operator*();

private:
	std::list<std::shared_ptr<Container>> over;
	ItemDeque::const_iterator cur;

	friend class Container;
};

class Container : public Item, public Cylinder {
public:
	explicit Container(uint16_t type);
	Container(uint16_t type, uint16_t size, bool unlocked = true, bool pagination = false);
	~Container() override;

	static std::shared_ptr<Container> create(uint16_t type);
	static std::shared_ptr<Container> create(uint16_t type, uint16_t size, bool unlocked = true, bool pagination = false);
	static std::shared_ptr<Container> create(const std::shared_ptr<Tile> &type);

	// non-copyable
	Container(const Container &) = delete;
	Container &operator=(const Container &) = delete;

	std::shared_ptr<Item> clone() const final;

	std::shared_ptr<Container> getContainer() final {
		return static_self_cast<Container>();
	}

	std::shared_ptr<const Container> getContainer() const final {
		return static_self_cast<Container>();
	}

	std::shared_ptr<Cylinder> getCylinder() override final {
		return getContainer();
	}

	std::shared_ptr<Container> getRootContainer();

	virtual std::shared_ptr<DepotLocker> getDepotLocker() {
		return nullptr;
	}

	virtual std::shared_ptr<RewardChest> getRewardChest() {
		return nullptr;
	}

	virtual std::shared_ptr<Reward> getReward() {
		return nullptr;
	}
	virtual bool isInbox() const {
		return false;
	}
	virtual bool isDepotChest() const {
		return false;
	}

	Attr_ReadValue readAttr(AttrTypes_t attr, PropStream &propStream) override;
	bool unserializeItemNode(OTB::Loader &loader, const OTB::Node &node, PropStream &propStream, Position &itemPosition) override;
	std::string getContentDescription(bool oldProtocol);

	uint32_t getMaxCapacity() const;

	size_t size() const {
		return itemlist.size();
	}
	bool empty() const {
		return itemlist.empty();
	}
	uint32_t capacity() const {
		return maxSize;
	}

	ContainerIterator iterator();

	const ItemDeque &getItemList() const {
		return itemlist;
	}

	ItemDeque::const_reverse_iterator getReversedItems() const {
		return itemlist.rbegin();
	}
	ItemDeque::const_reverse_iterator getReversedEnd() const {
		return itemlist.rend();
	}

	bool countsToLootAnalyzerBalance();
	bool hasParent();
	void addItem(const std::shared_ptr<Item> &item);
	StashContainerList getStowableItems() const;
	bool isStoreInbox() const;
	bool isStoreInboxFiltered() const;
	std::deque<std::shared_ptr<Item>> getStoreInboxFilteredItems() const;
	std::vector<ContainerCategory_t> getStoreInboxValidCategories() const;
	std::shared_ptr<Item> getFilteredItemByIndex(size_t index) const;
	std::shared_ptr<Item> getItemByIndex(size_t index) const;
	bool isHoldingItem(const std::shared_ptr<Item> &item);
	bool isHoldingItemWithId(uint16_t id);

	uint32_t getItemHoldingCount();
	uint32_t getContainerHoldingCount();
	uint16_t getFreeSlots();
	uint32_t getWeight() const final;

	bool isUnlocked() const {
		return !this->isCorpse() && unlocked;
	}
	bool hasPagination() const {
		return pagination;
	}

	// cylinder implementations
	virtual ReturnValue queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &actor = nullptr) override;
	ReturnValue queryMaxCount(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t &maxQueryCount, uint32_t flags) final;
	ReturnValue queryRemove(const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &actor = nullptr) override;
	std::shared_ptr<Cylinder> queryDestination(int32_t &index, const std::shared_ptr<Thing> &thing, std::shared_ptr<Item>* destItem, uint32_t &flags) final;

	void addThing(std::shared_ptr<Thing> thing) final;
	void addThing(int32_t index, const std::shared_ptr<Thing> &thing) final;
	void addItemBack(const std::shared_ptr<Item> &item);

	void updateThing(const std::shared_ptr<Thing> &thing, uint16_t itemId, uint32_t count) final;
	void replaceThing(uint32_t index, const std::shared_ptr<Thing> &thing) override final;

	void removeThing(const std::shared_ptr<Thing> &thing, uint32_t count) final;

	int32_t getThingIndex(const std::shared_ptr<Thing> &thing) const final;
	size_t getFirstIndex() const final;
	size_t getLastIndex() const final;
	uint32_t getItemTypeCount(uint16_t itemId, int32_t subType = -1) const final;
	std::map<uint32_t, uint32_t> &getAllItemTypeCount(std::map<uint32_t, uint32_t> &countMap) const final;
	std::shared_ptr<Thing> getThing(size_t index) const final;

	ItemVector getItems(bool recursive = false);

	void postAddNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &oldParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;
	void postRemoveNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &newParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;

	void internalAddThing(const std::shared_ptr<Thing> &thing) final;
	void internalAddThing(uint32_t index, const std::shared_ptr<Thing> &thing) final;
	void startDecaying() override;
	void stopDecaying() override;

	virtual void removeItem(std::shared_ptr<Thing> thing, bool sendUpdateToClient = false);

	uint32_t getOwnerId() const final;

	bool isAnyKindOfRewardChest();
	bool isAnyKindOfRewardContainer();
	bool isBrowseFieldAndHoldsRewardChest();
	bool isInsideContainerWithId(uint16_t id);

protected:
	std::ostringstream &getContentDescription(std::ostringstream &os, bool oldProtocol);

	uint32_t m_maxItems {};
	uint32_t maxSize;
	uint32_t totalWeight = 0;
	ItemDeque itemlist;
	uint32_t serializationCount = 0;

	bool unlocked;
	bool pagination;

	friend class MapCache;

private:
	void onAddContainerItem(const std::shared_ptr<Item> &item);
	void onUpdateContainerItem(uint32_t index, const std::shared_ptr<Item> &oldItem, const std::shared_ptr<Item> &newItem);
	void onRemoveContainerItem(uint32_t index, const std::shared_ptr<Item> &item);

	std::shared_ptr<Container> getParentContainer();
	std::shared_ptr<Container> getTopParentContainer();
	void updateItemWeight(int32_t diff);

	friend class ContainerIterator;
	friend class IOMapSerialize;
};
