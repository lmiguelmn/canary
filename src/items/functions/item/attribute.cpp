/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "items/functions/item/attribute.hpp"

/*
=============================
* ItemAttribute class (Attributes methods)
=============================
*/
const std::string &ItemAttribute::getAttributeString(ItemAttribute_t type) const {
	static std::string emptyString;
	if (!isAttributeString(type)) {
		return emptyString;
	}

	auto attribute = getAttribute(type);
	if (!attribute) {
		return emptyString;
	}

	return *attribute->getString().get();
}

const int64_t &ItemAttribute::getAttributeValue(ItemAttribute_t type) const {
	static int64_t emptyInt;
	if (!isAttributeInteger(type)) {
		return emptyInt;
	}

	auto attribute = getAttribute(type);
	if (!attribute) {
		return emptyInt;
	}

	return attribute->getInteger();
}

const Attributes* ItemAttribute::getAttribute(ItemAttribute_t type) const {
	if (hasAttribute(type)) {
		for (const Attributes &attribute : attributeVector) {
			if (attribute.getAttributeType() == type) {
				return &attribute;
			}
		}
	}
	return nullptr;
}

Attributes &ItemAttribute::getAttributesByType(ItemAttribute_t type) {
	if (hasAttribute(type)) {
		for (Attributes &attribute : attributeVector) {
			if (attribute.getAttributeType() == type) {
				return attribute;
			}
		}
	}

	attributeBits |= type;
	attributeVector.emplace_back(type);
	return attributeVector.back();
}

void ItemAttribute::setAttribute(ItemAttribute_t type, int64_t value) {
	if (!isAttributeInteger(type)) {
		return;
	}

	getAttributesByType(type).setValue(value);
}

void ItemAttribute::setAttribute(ItemAttribute_t type, const std::string &value) {
	if (!isAttributeString(type)) {
		return;
	}

	if (value.empty()) {
		return;
	}

	getAttributesByType(type).setValue(value);
}

bool ItemAttribute::removeAttribute(ItemAttribute_t type) {
	if (!hasAttribute(type)) {
		return false;
	}

	std::ranges::for_each(attributeVector, [this, type](auto &it) {
		if (it.getAttributeType() == type) {
			it = std::move(attributeVector.back());
			attributeVector.pop_back();
			return false;
		}

		return true;
	});

	attributeBits &= ~type;
	return true;
}

/*
=============================
* CustomAttribute map methods
=============================
*/
const std::map<std::string, CustomAttribute, std::less<>> &ItemAttribute::getCustomAttributeMap() const {
	return customAttributeMap;
}

/*
=============================
* CustomAttribute object methods
=============================
*/
const CustomAttribute* ItemAttribute::getCustomAttribute(const std::string &attributeName) const {
	if (customAttributeMap.contains(asLowerCaseString(attributeName))) {
		return &customAttributeMap.at(asLowerCaseString(attributeName));
	}
	return nullptr;
}

void ItemAttribute::setCustomAttribute(const std::string &key, const int64_t value) {
	CustomAttribute attribute(key, value);
	customAttributeMap[asLowerCaseString(key)] = attribute;
}

void ItemAttribute::setCustomAttribute(const std::string &key, const std::string &value) {
	CustomAttribute attribute(key, value);
	customAttributeMap[asLowerCaseString(key)] = attribute;
}

void ItemAttribute::setCustomAttribute(const std::string &key, const double value) {
	CustomAttribute attribute(key, value);
	customAttributeMap[asLowerCaseString(key)] = attribute;
}

void ItemAttribute::setCustomAttribute(const std::string &key, const bool value) {
	CustomAttribute attribute(key, value);
	customAttributeMap[asLowerCaseString(key)] = attribute;
}

void ItemAttribute::addCustomAttribute(const std::string &key, const CustomAttribute &customAttribute) {
	customAttributeMap[asLowerCaseString(key)] = customAttribute;
}

bool ItemAttribute::removeCustomAttribute(const std::string &attributeName) {
	auto it = customAttributeMap.find(asLowerCaseString(attributeName));
	if (it == customAttributeMap.end()) {
		return false;
	}

	customAttributeMap.erase(it);
	return true;
}
