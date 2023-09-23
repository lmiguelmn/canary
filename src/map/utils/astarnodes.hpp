/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class Position;
class Creature;
class Tile;

struct AStarNode {
	AStarNode* parent;
	int_fast32_t f;
	uint16_t x, y;
};

class AStarNodes {
public:
	AStarNodes(uint32_t x, uint32_t y);

	AStarNode* createOpenNode(AStarNode* parent, uint32_t x, uint32_t y, int_fast32_t f);
	AStarNode* getBestNode();
	void closeNode(const AStarNode* node);
	void openNode(const AStarNode* node);
	int_fast32_t getClosedNodes() const;
	AStarNode* getNodeByPosition(uint32_t x, uint32_t y);

	static int_fast32_t getMapWalkCost(AStarNode* node, const Position &neighborPos, bool preferDiagonal = false);
	static int_fast32_t getTileWalkCost(const std::shared_ptr<Creature> &creature, std::shared_ptr<Tile> tile);

private:
	static constexpr int32_t MAX_NODES = 512;
	static constexpr int32_t MAP_NORMALWALKCOST = 10;
	static constexpr int32_t MAP_PREFERDIAGONALWALKCOST = 14;
	static constexpr int32_t MAP_DIAGONALWALKCOST = 25;

	AStarNode nodes[MAX_NODES];
	bool openNodes[MAX_NODES];
	phmap::flat_hash_map<uint32_t, AStarNode*> nodeTable;
	size_t curNode;
	int_fast32_t closedNodes;
};
