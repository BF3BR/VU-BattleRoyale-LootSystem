import React from 'react';
import { getItemType } from '../helpers/InventoryHelper';

import "./LootOverlay.scss";

interface Props {
    loot: any;
}

const LootOverlay: React.FC<Props> = ({ loot }) => {
    return (
        <div className="lootOverlay">
            <div className={"tier " + (loot.Tier !== undefined ? "tier-" + loot.Tier : "tier-1")}>
                {loot.UIIcon !== null &&
                    <div className="image">
                        <img src={"fb://" + loot.UIIcon} />
                    </div>
                }
                <div className="information">
                    <span className="name">{loot.Name ?? ""}</span>
                    {/*loot.Quantity > 1 &&
                        <span className="count">{loot.Quantity ?? 1}</span>
                    */}
                    <span className="ammoType">
                        {getItemType(loot.Type)}
                    </span>
                    {/*(loot.CurrentDurability !== undefined && loot.Durability !== undefined) &&
                        <div className="progressWrapper">
                            <div className="progressWrapperBg">
                                <div className="progressWrapperFg" style={{ height: (loot.CurrentDurability / loot.Durability * 100) + "%" }}></div>
                            </div>
                        </div>
                    */}
                    {loot.Tier !== undefined &&
                        <span className="tier">
                            {loot.Tier === 1 &&
                                <img src="fb://UI/Art/Persistence/Ranks/Rank001" />
                            }
                            {loot.Tier === 2 &&
                                <img src="fb://UI/Art/Persistence/Ranks/Rank002" />
                            }
                            {loot.Tier === 3 &&
                                <img src="fb://UI/Art/Persistence/Ranks/Rank003" />
                            }
                        </span>
                    }
                </div>
            </div>
            <div className="keyinfo">
                <h4>Press E to pickup</h4>
            </div>
        </div>
    )
};

export default React.memo(LootOverlay);
